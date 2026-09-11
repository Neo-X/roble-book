#!/usr/bin/env -S uv run --script

# /// script
# requires-python = ">=3.9"
# dependencies = []
# ///

"""Pandoc JSON filter to rewrite SVG images to PDFs for LaTeX/Beamer builds.

TODO: Support newer pandoc versions (3.x+). The JSON AST format changed between
pandoc 2.x and 3.x — the top-level wrapper key and Image node layout may differ.
Test and update rewrite_node / extract_format against a recent pandoc release.
"""

import json
import mimetypes
import os
import re
import subprocess
import sys
from urllib.parse import unquote
from urllib.request import urlretrieve

FMT_TO_OPTION = {
    "latex": ("--export-filename=", "pdf"),
    "beamer": ("--export-filename=", "pdf"),
    "docx": ("--export-filename=", "png"),
    "html": ("--export-filename=", "png"),
}


def normalize_format(fmt):
    if not isinstance(fmt, str) or not fmt:
        return None
    fmt = fmt.lower()
    return re.split(r"[+-]", fmt, maxsplit=1)[0]


def extract_format(document):
    if len(sys.argv) > 1:
        fmt = normalize_format(sys.argv[1])
        if fmt:
            return fmt

    for key in ("format", "writer", "target"):
        value = document.get(key)
        fmt = normalize_format(value)
        if fmt:
            return fmt

    for env_key in ("PANDOC_TARGET_FORMAT", "PANDOC_FORMAT"):
        fmt = normalize_format(os.environ.get(env_key))
        if fmt:
            return fmt

    return None


def normalize_source(source):
    if re.match(r"https?://", source):
        source_match = re.sub(r"\?.+", "", source)
        source_match = re.sub(r"\#.+", "", source_match)
        return re.sub(r"/$", "", source_match)
    return source


def convert_svg(source, fmt):
    option = FMT_TO_OPTION.get(fmt)
    if option is None and fmt is None:
        option = FMT_TO_OPTION["latex"]

    source_match = normalize_source(source)
    mime_type, _ = mimetypes.guess_type(source_match)
    is_svg = mime_type == "image/svg+xml" or source_match.lower().endswith(".svg")
    if not is_svg or option is None:
        return source

    if re.match(r"https?://", source):
        basename = unquote(os.path.basename(source_match))
        basename = re.sub(r"[^a-zA-Z0-9\.]", "", basename)
        source, _ = urlretrieve(source, basename)
        base_name, _ = os.path.splitext(basename)
        target = base_name + "." + option[1]
    else:
        base_name, _ = os.path.splitext(source)
        target = os.path.realpath(base_name + "." + option[1])
        source = os.path.realpath(source)

    try:
        target_mtime = os.path.getmtime(target)
    except OSError:
        target_mtime = -1

    if target_mtime < os.path.getmtime(source):
        command = ["inkscape", option[0] + target, source]
        sys.stderr.write(f"Running {' '.join(command)}\n")
        subprocess.run(command, check=False, stdout=sys.stderr, stderr=sys.stderr)

    return target


def rewrite_node(node, fmt):
    if isinstance(node, dict):
        node_type = node.get("t")
        if node_type == "Image":
            value = node.get("c", [])
            if len(value) >= 3 and isinstance(value[2], list) and len(value[2]) == 2:
                source, title = value[2]
                value[2] = [convert_svg(source, fmt), title]
            node["c"] = [rewrite_node(item, fmt) for item in value]
            return node
        return {key: rewrite_node(value, fmt) for key, value in node.items()}
    if isinstance(node, list):
        return [rewrite_node(item, fmt) for item in node]
    return node


if __name__ == "__main__":
    document = json.load(sys.stdin)
    document = rewrite_node(document, extract_format(document))
    json.dump(document, sys.stdout)