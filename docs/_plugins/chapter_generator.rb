require 'open3'
require 'fileutils'
require 'pathname'

module Jekyll
  # Finds every _lectures/lecXX/text.md, runs pandoc on it, and writes
  # the resulting HTML fragment to _includes/chapters/lecXX-content.html.
  # Images already live in _lectures/lecXX/ and are served by Jekyll as
  # static files; cross-lecture images are served from _lectures/<sibling>/.
  class ChapterGenerator < Generator
    safe false
    priority :high

    PANDOC_DIR   = File.join(__dir__, '..', '_pandoc')
    LECTURES_DIR = File.join(__dir__, '..', '_lectures')

    def generate(site)
      Dir.glob(File.join(LECTURES_DIR, '*', 'text.md')).sort.each do |text_md|
        lec_dir = File.dirname(text_md)
        lec_id  = File.basename(lec_dir)
        build_chapter(site, lec_id, lec_dir, text_md)
      end
    end

    private

    def build_chapter(site, lec_id, lec_dir, text_md)
      includes_dir = File.join(site.source, '_includes', 'chapters')
      FileUtils.mkdir_p(includes_dir)

      html = run_pandoc(lec_dir, text_md)
      return unless html

      html = fix_paths(html, lec_id)

      out = File.join(includes_dir, "#{lec_id}-content.html")
      File.write(out, html)
      Jekyll.logger.info 'ChapterGenerator:', "#{lec_id} → _includes/chapters/#{lec_id}-content.html (#{html.bytesize} B)"
    end

    def run_pandoc(lec_dir, text_md)
      defs    = File.join(PANDOC_DIR, 'defs.md')
      lua     = File.join(PANDOC_DIR, 'flatten-layout.lua')
      svg_flt = File.join(PANDOC_DIR, 'pandoc-svg.py')
      bib_src = File.join(PANDOC_DIR, 'sample.bib')
      tmp_bib = '/tmp/chapter-bib.bib'

      # Strip noisy bib fields that can cause citeproc warnings
      filtered = File.readlines(bib_src)
                     .reject { |l| l.match?(/^\s*@(issn|url|doi|isbn|pages|numpages)\s*=/i) }
      File.write(tmp_bib, filtered.join)

      cmd = %W[
        pandoc
        --filter=#{svg_flt}
        #{defs} #{text_md}
        --lua-filter=#{lua}
        --mathjax
        --bibliography=#{tmp_bib} --citeproc
        --metadata=link-citations:true
        --metadata=reference-section-title:References
        -t html
      ]

      stdout, stderr, status = Open3.capture3(*cmd, chdir: lec_dir)

      unless status.success?
        Jekyll.logger.error 'ChapterGenerator:', "pandoc failed:\n#{stderr.lines.last(5).join}"
        return nil
      end

      stdout
    end

    # Rewrite image src paths to /assets/chapters/ where Jekyll serves them.
    # ../sibling/figures/x.png  →  /assets/chapters/sibling/figures/x.png
    # local/relative/image.png  →  /assets/chapters/lec_id/local/relative/image.png
    def fix_paths(html, lec_id)
      html = html.gsub(/src="\.\.\/([^"]+)"/, 'src="/assets/chapters/\1"')
      html = html.gsub(/src="(?!\/)([^"]+)"/, "src=\"/assets/chapters/#{lec_id}/\\1\"")
      html
    end
  end
end
