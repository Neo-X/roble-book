.PHONY: install serve build clean

# Jekyll's source lives in docs/ (required by GitHub Pages' "/docs" deploy
# setting), but Jekyll itself only looks for _config.yml in the current
# directory, so these targets exist to run everything correctly from the
# repo root instead of requiring `cd docs` first.

install:
	bundle install

serve:
	cd docs && bundle exec jekyll serve --baseurl ""

build:
	cd docs && bundle exec jekyll build

clean:
	cd docs && bundle exec jekyll clean
