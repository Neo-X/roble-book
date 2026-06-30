# CLAUDE.md — roble-book

## Purpose

This repository hosts the public website for **Robot Learning (IFT 6163)**, a graduate course taught by Glen Berseth at Université de Montréal / Mila. The site will eventually live at `robotlearningbook.com` (see `PROGRESS.md` for the custom-domain setup steps).

The long-term goal is a full online textbook. Right now the site serves as a landing page that surfaces:
- All 28 lecture slide decks (linked to Google Drive PDFs)
- YouTube video recordings (playlist + per-lecture links when available)
- Colab notebooks for hands-on exercises
- Chapter PDFs as textbook prose is completed

The slide sources, transcripts, and LaTeX book chapters live in a **companion repository**: `../RobotLearningLectures/`. That repo has its own `CLAUDE.md` describing the textbook conversion workflow. This repo (`roble-book`) is only the website.

---

## How to Work With This Repo

See **[README.md](README.md)** for full details on:
- Local development setup
- The `buildbook.sh` sync workflow (how to pull chapter content from `../RobotLearningLectures/`)
- The chapter content structure (`lecXX.md` header files, `text.md` sources, figures, PDFs)
- How to add a new lecture chapter

Quick reference for common tasks:

| Task | Where to edit |
|------|--------------|
| Sync chapter content from source repo | Run `./buildbook.sh` from repo root |
| Add/change a lecture's metadata or description | `docs/_lectures/lecXX.md` front matter |
| Wire up a YouTube video ID | `docs/_lectures/lecXX.md` → set `youtube_id:` |
| Link a slides PDF | `docs/_lectures/lecXX.md` → set `slides_url:` |
| Link a chapter PDF | `docs/_lectures/lecXX.md` → set `chapter_url:` and `chapter_content_include:` |
| Change site title / author / playlist URL | `docs/_config.yml` |
| Change page layout or nav | `docs/_layouts/default.html` |
| Change lecture page layout | `docs/_layouts/lecture.html` |
| Change visual styles | `docs/assets/css/style.css` |

## Key Rules

- **Chapter subdirectories (`_lectures/lecXX-Name/`) are never published as pages.** They exist only as source input for the `ChapterGenerator` plugin. Jekyll is configured to suppress them via `defaults` entries in `_config.yml` — one entry per chapter directory. When adding a new chapter via `buildbook.sh`, add a matching `published: false` default to `_config.yml`.
- **`lecXX.md` files are metadata-only headers.** Do not add prose body content to them. The chapter body is injected by the `lecture.html` layout using the `chapter_content_include` front matter field.
- **Never edit files under `_lectures/lecXX-Name/` or `assets/chapters/lecXX-Name/` directly.** They are overwritten by `buildbook.sh` on the next sync. Edit the source in `../RobotLearningLectures/` instead.

See **[README.md](README.md)** for the full chapter structure and workflow details.

---

## Repository Structure

```
roble-book/
  CLAUDE.md          ← this file
  README.md          ← full workflow docs (read this first)
  buildbook.sh       ← sync content from RobotLearningLectures + build
  PROGRESS.md        ← todo list and milestone tracker
  .gitignore
  docs/              ← Jekyll site root (GitHub Pages serves from here)
    _config.yml      ← site metadata, collection config, gem settings
    Gemfile          ← Ruby gem versions
    index.md         ← home page
    _lectures/
      lecXX.md       ← metadata header per lecture (front matter only)
      lec00-WhatIsRobotLearning/text.md   ← chapter prose (synced by buildbook.sh)
      lec01-SupervisedLearning/text.md    ← chapter prose (synced by buildbook.sh)
    _layouts/
      default.html   ← base HTML shell
      lecture.html   ← individual lecture page
    _plugins/
      chapter_generator.rb  ← compiles text.md → _includes/chapters/*-content.html
    _pandoc/
      pandoc-svg.py  ← pandoc filter (SVG pass-through for HTML, convert for LaTeX)
    assets/
      css/style.css
      chapters/
        lec00-WhatIsRobotLearning/   ← figures/ + chapter.pdf (synced by buildbook.sh)
        lec01-SupervisedLearning/    ← figures/ + chapter.pdf (synced by buildbook.sh)
```

---

## Deployment

GitHub Pages builds the site automatically on every push to `main`.

**Enable once:** Repo Settings → Pages → Source: `main` branch, folder `/docs`.

The live URL will be `https://neo-x.github.io/roble-book/` until the custom domain `robotlearningbook.com` is configured (see `PROGRESS.md`).

---

## Related Repositories

| Repo | Purpose |
|------|---------|
| `../RobotLearningLectures/` | Slide sources (`talk.md`), transcripts, LaTeX chapters — the content that feeds this site |
| `../neo-x.github.io/` | Glen's main academic website; same Jekyll + minima gem versions used here |
