# Robot Learning — IFT 6163

GitHub Pages site for Glen Berseth's Robot Learning course (Université de Montréal / Mila).

**Live site:** https://neo-x.github.io/roble-book/

## Local Development

```bash
cd docs
bundle install          # first time only
bundle exec jekyll serve --baseurl ""
# → open http://localhost:4000
```

## Enabling GitHub Pages

1. Push this repo to GitHub.
2. Go to **Repo Settings → Pages**.
3. Under *Source*, select **Deploy from branch**.
4. Set **Branch: main** and **Folder: /docs**, then save.

The site is built automatically by GitHub's Jekyll engine — no local build step needed.

## Updating lecture links

Edit [`docs/_data/lectures.yml`](docs/_data/lectures.yml):

```yaml
- num: "06"
  title: "Policy Gradients"
  track: "Policy Gradient Methods"
  youtube_id: "xxxxxxxxxxx"      # ← part after ?v= in the YouTube watch URL
  slides_url: "https://..."      # ← link to slides PDF or HTML
  chapter_url: "https://..."     # ← link to book chapter PDF
```

When `youtube_id` is blank, the Video button links to the full playlist.

## Adding new pages

Any `.md` file in `docs/` with `layout: default` in its front matter becomes a page.
The home page is [`docs/index.md`](docs/index.md).

## Lecture source

Slide sources and transcripts live in a companion repo: `RobotLearningLectures/`.  
YouTube playlist: https://youtube.com/playlist?list=PLMe2pHxzxHp-UJ1jd-uuGSGK7P7Phtm-f
