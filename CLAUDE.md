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

## Repository Structure

```
roble-book/
  CLAUDE.md          ← this file
  PROGRESS.md        ← todo list and milestone tracker
  README.md          ← setup instructions for GitHub Pages
  .gitignore
  docs/              ← Jekyll site root (GitHub Pages serves from here)
    _config.yml      ← site metadata, collection config, gem settings
    Gemfile          ← Ruby gem versions (Jekyll 4.2.1, minima 2.5)
    index.md         ← home page (Markdown + Liquid; loops over site.lectures)
    _lectures/       ← one .md file per lecture (the Jekyll Collection)
    _layouts/
      default.html   ← base HTML shell (header, nav, footer)
      lecture.html   ← individual lecture page (video embed, download buttons)
    assets/
      css/style.css  ← all styles
```

---

## The Lectures Collection

Each lecture is a Markdown file in `docs/_lectures/` with YAML front matter:

```markdown
---
num: "06"
title: "Policy Gradients"
track: "Policy Gradient Methods"
youtube_id:             # part after ?v= in the YouTube watch URL; blank = link to playlist
slides_url: "https://drive.google.com/file/d/FILEID/view"
colab_url:              # Colab link if there is a notebook
chapter_url:            # link to chapter PDF once available
description: >
  One-paragraph summary shown on the index card and lecture page header.
---

Markdown body: overview paragraphs, ### Key topics list, etc.
```

`_config.yml` configures the collection with `output: true` and `permalink: /lectures/:name/`, so Jekyll generates a page at e.g. `/lectures/lec06/` for each file automatically.

The index page (`index.md`) iterates over `site.lectures` sorted by `num`, groups them by `track`, and renders a card grid. Each card links to the lecture's individual page.

---

## Local Development

Gems are installed locally into `docs/vendor/bundle` (not system-wide).

```bash
cd docs
bundle install          # first time only
bundle exec jekyll serve --baseurl ""
# → open http://localhost:4000
```

The `--baseurl ""` override prevents the `/roble-book` production prefix from breaking local links.

---

## Updating Content

| Task | Where to edit |
|------|--------------|
| Add/change a lecture description or key topics | `docs/_lectures/lecXX.md` body |
| Wire up a YouTube video ID | `docs/_lectures/lecXX.md` → set `youtube_id:` |
| Link a slides PDF | `docs/_lectures/lecXX.md` → set `slides_url:` (use Google Drive view URL) |
| Link a chapter PDF | `docs/_lectures/lecXX.md` → set `chapter_url:` |
| Change site title / author / playlist URL | `docs/_config.yml` |
| Change page layout or nav | `docs/_layouts/default.html` |
| Change lecture page layout | `docs/_layouts/lecture.html` |
| Change visual styles | `docs/assets/css/style.css` |

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
