# Robot Learning — IFT 6163

GitHub Pages site for Glen Berseth's Robot Learning course (Université de Montréal / Mila).

**Live site:** https://neo-x.github.io/roble-book/

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

## Building the Textbook Content

Textbook chapter prose lives in the companion repo **`../RobotLearningLectures/`**. Run `buildbook.sh` from the repo root to sync content into this website and verify the build:

```bash
./buildbook.sh            # sync all lectures with compiled chapters, then build
./buildbook.sh lec00      # sync only lec00, then build
./buildbook.sh --no-build # sync without building
```

`buildbook.sh` copies three things per lecture from `../RobotLearningLectures/<src-name>/`:

| Source (RobotLearningLectures) | Destination (roble-book/docs) |
|-------------------------------|-------------------------------|
| `<src-name>/text.md` | `_lectures/<src-name>/text.md` |
| `<src-name>/figures/` | `assets/chapters/<src-name>/figures/` |
| `<src-name>/chapter.pdf` | `assets/chapters/<src-name>/chapter.pdf` |

LaTeX build artifacts (`.aux`, `.log`, `.tex`, `.pdf` in figures, `.mp4`, etc.) are excluded from the figures sync.

To add a new lecture chapter, add one line to the `LECTURE_MAP` in `buildbook.sh`:

```bash
["lec02"]="lec02-IntroToDeepRL"
```

---

## Chapter Content Structure

Each lecture that has compiled chapter prose follows this pattern:

### 1. Header file — `docs/_lectures/lecXX.md`

Contains only YAML front matter. **Do not put prose here** — it is a metadata header that links videos, slides, and the chapter together.

```yaml
---
num: "00"
title: "What Is Robot Learning?"
track: "Foundations"
youtube_id: "1ZuvCWvj0HM"
slides_url: "https://drive.google.com/file/d/…/view"
colab_url:                    # Colab notebook link (leave blank if none)
chapter_url: "/assets/chapters/lec00-WhatIsRobotLearning/chapter.pdf"
chapter_content_include: "chapters/lec00-WhatIsRobotLearning-content.html"
description: >
  One-paragraph summary shown on the index card and lecture page header.
---
```

- `chapter_url` — links the "Chapter PDF" button to the compiled PDF in `assets/`
- `chapter_content_include` — tells `lecture.html` which generated HTML fragment to embed as the chapter body

### 2. Chapter source — `docs/_lectures/<src-name>/text.md`

Populated by `buildbook.sh`. Pandoc prose with figures referenced relative to the chapter directory. The Jekyll plugin `_plugins/chapter_generator.rb` compiles this with pandoc on every build and writes the result to `_includes/chapters/<src-name>-content.html`.

### 3. Figures — `docs/assets/chapters/<src-name>/figures/`

Static image assets served by Jekyll. Referenced in `text.md` as `../lec00-WhatIsRobotLearning/figures/image.png`; the generator rewrites these to `/assets/chapters/lec00-WhatIsRobotLearning/figures/image.png` in the HTML output.

### 4. Chapter PDF — `docs/assets/chapters/<src-name>/chapter.pdf`

Pre-built PDF, linked by the "Chapter PDF" button. Copied from the source repo by `buildbook.sh`.

---

## Updating Lecture Metadata

Edit `docs/_lectures/lecXX.md` front matter only:

| Task | Field |
|------|-------|
| Wire up a YouTube video | `youtube_id:` (the part after `?v=`) |
| Link slides PDF | `slides_url:` (Google Drive view URL) |
| Link chapter PDF | `chapter_url:` |
| Enable chapter body | `chapter_content_include:` |
| Change description | `description:` |

---

## Enabling GitHub Pages

1. Push this repo to GitHub.
2. Go to **Repo Settings → Pages**.
3. Under *Source*, select **Deploy from branch**.
4. Set **Branch: main** and **Folder: /docs**, then save.

GitHub's Jekyll engine builds the site automatically on every push — no local build step needed for deployment.

**Live URL:** `https://neo-x.github.io/roble-book/` (custom domain `robotlearningbook.com` pending — see `PROGRESS.md`).

---

## Related Repositories

| Repo | Purpose |
|------|---------|
| `../RobotLearningLectures/` | Slide sources (`talk.md`), transcripts, LaTeX chapters — the content that feeds this site |
| `../neo-x.github.io/` | Glen's main academic website |
