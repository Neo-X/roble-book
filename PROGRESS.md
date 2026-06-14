# Robot Learning Book — Site Progress

## Done

- [x] Jekyll site scaffolded in `docs/` with collections-based lecture pages
- [x] 28 lecture Markdown files (`docs/_lectures/lec00.md` – `lec26.md`) with descriptions and topic outlines
- [x] Google Drive slide PDF links wired into 18 lectures
- [x] Colab notebook links for lec01 (Behavior Cloning), lec05 (MBRL), lec08 (Q-iteration)
- [x] Index page groups lectures by track with cards linking to individual pages
- [x] Individual lecture pages with embedded YouTube player (when video ID is set), download buttons, and key-topics prose
- [x] Gemfile pinned to Jekyll 4.2.1 (matching `neo-x.github.io`) with gems installed locally via `vendor/bundle`
- [x] `.gitignore` excludes `vendor/`, `_site/`, `.jekyll-cache/`
- [x] Local build confirmed working (`bundle exec jekyll build --baseurl ""`)
- [x] Readings imported from Notion CSV into lecture front matter (`readings:` list with `required: true` flags)
- [x] Reading summary Overleaf template linked on every lecture page
- [x] Assignments button in header links to `https://github.com/milarobotlearningcourse` with WIP badge
- [x] Course info pages drafted from Notion export and saved (unpublished) for future use:
  - `docs/faq.md` — Piazza/Discord guidelines and regrade policy
  - `docs/course-project.md` — project scope, team expectations, grading, probation policy
  - `docs/resources.md` — textbooks, courses, environments
  - `docs/ai-policy.md` — generative AI usage rules
  - `docs/assignments.md` — programming assignment overview and late policy
  - All four (faq, course-project, resources, ai-policy) have `published: false`; add to site when ready

## In Progress

- [ ] Add individual YouTube video IDs to each lecture file (currently all fall back to playlist)
- [ ] Polish look and feel to match `neo-x.github.io` visual style

## To Do

### Content
- [ ] **Actor-Critic (lec07)** — slides already exist; find the older recorded lecture and add to site. Once video ID is known, restore `docs/_lectures/lec07.md` with `slides_url` and `youtube_id`.
- [ ] Add remaining slide PDFs to Google Drive and link into lectures missing `slides_url`:
  lec02, lec10, lec12b, lec13, lec19
- [ ] Add chapter PDF links as textbook chapters are completed
- [ ] Add course syllabus / schedule page

### Infrastructure
- [ ] Push `roble-book` repo to GitHub
- [ ] Enable GitHub Pages: Repo Settings → Pages → Branch: `main`, Folder: `/docs`
- [ ] Verify live site at `https://neo-x.github.io/roble-book/`
- [ ] Point custom domain `robotlearningbook.com` to GitHub Pages
  - Add `CNAME` file to `docs/` containing `robotlearningbook.com`
  - In domain registrar DNS: add CNAME record `www → neo-x.github.io` and A records for GitHub Pages IPs
  - In GitHub repo settings: set custom domain to `robotlearningbook.com` and enable HTTPS
- [ ] Update `url` and `baseurl` in `docs/_config.yml` once custom domain is live
