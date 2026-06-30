#!/usr/bin/env bash
# buildbook.sh — Sync textbook content from RobotLearningLectures into the website,
# then build the Jekyll site to verify everything compiles.
#
# Usage:
#   ./buildbook.sh           # sync all configured lectures and build
#   ./buildbook.sh lec00     # sync only lec00, then build
#   ./buildbook.sh --no-build lec01  # sync only, skip the Jekyll build
#
# Source repo is expected at ../RobotLearningLectures/ relative to this repo.
# Override with: LECTURES_REPO=/path/to/RobotLearningLectures ./buildbook.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LECTURES_REPO="${LECTURES_REPO:-"$REPO_ROOT/../RobotLearningLectures"}"
DOCS="$REPO_ROOT/docs"

# Mapping: short-id → source directory name in RobotLearningLectures
# Add a new entry here when a lecture gains a compiled chapter.
declare -A LECTURE_MAP=(
    ["lec00"]="lec00-WhatIsRobotLearning"
    ["lec01"]="lec01-SupervisedLearning"
)

# Files/extensions to exclude when syncing figures (LaTeX build artifacts)
RSYNC_EXCLUDES=(
    --exclude="*.aux"
    --exclude="*.log"
    --exclude="*.tex"
    --exclude="*.bbl"
    --exclude="*.blg"
    --exclude="*.out"
    --exclude="*.toc"
    --exclude="*.pdf"
    --exclude="*.mp4"
    --exclude="*.snm"
    --exclude="*.nav"
    --exclude="*.vrb"
)

# ── Parse arguments ───────────────────────────────────────────────────────────
DO_BUILD=true
SELECTED=()

for arg in "$@"; do
    case "$arg" in
        --no-build) DO_BUILD=false ;;
        *) SELECTED+=("$arg") ;;
    esac
done

# If no lectures specified, sync all
if [[ ${#SELECTED[@]} -eq 0 ]]; then
    SELECTED=("${!LECTURE_MAP[@]}")
fi

# ── Validate source repo ──────────────────────────────────────────────────────
if [[ ! -d "$LECTURES_REPO" ]]; then
    echo "ERROR: RobotLearningLectures repo not found at: $LECTURES_REPO"
    echo "Set LECTURES_REPO env var to point to the correct path."
    exit 1
fi

echo "Source repo : $LECTURES_REPO"
echo "Website docs: $DOCS"
echo ""

# ── Sync each lecture ─────────────────────────────────────────────────────────
for lec_id in "${SELECTED[@]}"; do
    src_name="${LECTURE_MAP[$lec_id]:-}"
    if [[ -z "$src_name" ]]; then
        echo "SKIP: '$lec_id' not in LECTURE_MAP (edit buildbook.sh to add it)"
        continue
    fi

    src_dir="$LECTURES_REPO/$src_name"
    if [[ ! -d "$src_dir" ]]; then
        echo "SKIP: source directory not found: $src_dir"
        continue
    fi

    echo "=== $lec_id ($src_name) ==="

    # 1. text.md → docs/_lectures/<src_name>/text.md
    #    The ChapterGenerator plugin picks up every _lectures/*/text.md and
    #    compiles it with pandoc into _includes/chapters/<src_name>-content.html.
    #    The lecture front matter (docs/_lectures/<lec_id>.md) then references
    #    that include via chapter_content_include.
    lec_content_dir="$DOCS/_lectures/$src_name"
    mkdir -p "$lec_content_dir"
    cp "$src_dir/text.md" "$lec_content_dir/text.md"
    # Ensure Jekyll never publishes text.md as a collection page
    if ! grep -q "^published:" "$lec_content_dir/text.md"; then
        sed -i "s/^---$/---\npublished: false/" "$lec_content_dir/text.md"
    fi
    echo "  ✓ text.md → _lectures/$src_name/"

    # 2. figures/ → docs/assets/chapters/<src_name>/figures/
    #    Excludes LaTeX build artifacts; keeps images (png, svg, jpg, gif, webp).
    if [[ -d "$src_dir/figures" ]]; then
        assets_dir="$DOCS/assets/chapters/$src_name"
        mkdir -p "$assets_dir"
        rsync -a --delete "${RSYNC_EXCLUDES[@]}" "$src_dir/figures/" "$assets_dir/figures/"
        echo "  ✓ figures/ → assets/chapters/$src_name/figures/"
    fi

    # 3. chapter.pdf → docs/assets/chapters/<src_name>/chapter.pdf
    if [[ -f "$src_dir/chapter.pdf" ]]; then
        assets_dir="$DOCS/assets/chapters/$src_name"
        mkdir -p "$assets_dir"
        cp "$src_dir/chapter.pdf" "$assets_dir/chapter.pdf"
        echo "  ✓ chapter.pdf → assets/chapters/$src_name/"
    fi

    echo ""
done

# ── Build the site ────────────────────────────────────────────────────────────
if [[ "$DO_BUILD" == true ]]; then
    echo "=== Building Jekyll site ==="
    cd "$DOCS"
    bundle exec jekyll build
    echo ""
    echo "Build succeeded. Site output: docs/_site/"
else
    echo "Skipping build (--no-build). Run 'cd docs && bundle exec jekyll build' to verify."
fi
