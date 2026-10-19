# Robot Learning — IFT 6163

GitHub Pages site for Glen Berseth's Robot Learning course (Université de Montréal / Mila).

**Live site:** https://neo-x.github.io/roble-book/

---

## Local Development

The `Gemfile` lives at the repo root; gems are installed locally into `vendor/bundle` (not system-wide). The Jekyll site itself lives in `docs/` (required by GitHub Pages' "/docs" deploy setting), and Jekyll only looks for `_config.yml` in the current directory — running `jekyll` directly from the repo root silently uses the wrong site source. Use the `Makefile` targets to always run everything correctly from the repo root:

```bash
make install   # bundle install, first time only
make serve     # → open http://localhost:4000
make build     # one-off build, output in docs/_site
```

If you'd rather run `bundle exec jekyll ...` directly, `cd docs` first.

The `--baseurl ""` override prevents the `/roble-book` production prefix from breaking local links.

---

## Building the Textbook Content

Textbook chapter prose lives in the companion repo **`../RobotLearningLectures/`**. Run `buildbook.sh` from the repo root to sync content into this website and verify the build:

```bash
./buildbook.sh            # sync all lectures with compiled chapters, then build
./buildbook.sh lec00      # sync only lec00, then build
./buildbook.sh --no-build # sync without building
```

`buildbook.sh` links (relative symlinks, never copies) three things per lecture from `../RobotLearningLectures/<src-name>/`, plus the figures/ of any other lecture a chapter borrows from and the shared pandoc inputs in `_pandoc/`:

| Source (RobotLearningLectures) | Link in roble-book/docs |
|-------------------------------|-------------------------------|
| `<src-name>/text.md` | `_lectures/<src-name>/text.md` |
| `<src-name>/figures/` | `assets/chapters/<src-name>/figures/` |
| `<src-name>/chapter.pdf` | `assets/chapters/<src-name>/chapter.pdf` |

Only the links are committed here, so images live in one place. The `exclude` list in `docs/_config.yml` keeps everything in `figures/` except images (scripts, `.aux`, `.tex`, figure PDFs, ...) out of `_site`, and `docs/_plugins/dereference_symlinks.rb` replaces linked files in `_site` with real copies so `deploy.sh` uploads files, not links. Deploying therefore needs `../RobotLearningLectures` checked out next to this repo, with each chapter's `chapter.pdf` built.

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

Pre-built PDF, linked by the "Chapter PDF" button. A symlink to the source repo's `chapter.pdf`, which `make chapter` builds there.

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
