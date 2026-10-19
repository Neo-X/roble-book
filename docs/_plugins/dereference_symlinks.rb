require 'fileutils'

# Chapter assets (assets/chapters/<lec>/chapter.pdf, figures/) are relative
# symlinks into ../RobotLearningLectures so they are never duplicated in this
# repo (see buildbook.sh). Jekyll copies a symlinked *file* into _site as the
# same relative link, which resolves to nothing one directory deeper and would
# upload as a dangling link. After every write, replace each such output link
# with a real copy of the source file it came from.
# Jekyll only deletes an existing output file before copying over it when
# File.exist? is true, which is false for a dangling link, so clear any left
# behind (e.g. by an interrupted build) before writing.
Jekyll::Hooks.register :site, :pre_render do |site|
  site.static_files.each do |file|
    dest = file.destination(site.dest)
    File.delete(dest) if File.symlink?(dest) && !File.exist?(dest)
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  site.static_files.each do |file|
    dest = file.destination(site.dest)
    next unless File.symlink?(dest)

    File.delete(dest)
    FileUtils.cp(File.realpath(file.path), dest)
  end
end
