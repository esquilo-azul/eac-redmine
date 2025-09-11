# frozen_string_literal: true

module Avm
  class Sync
    attr_reader :excludes, :includes

    common_constructor :source_path, :target_path do
      self.source_path = source_path.to_pathname
      self.target_path = target_path.to_pathname
      @excludes = []
      @includes = []
    end

    def run
      clear_target
      copy
    end

    def add_exclude(exclude)
      excludes << exclude

      self
    end

    def add_excludes(*excludes)
      excludes.each { |exclude| add_exclude(exclude) }

      self
    end

    def add_include(include)
      includes << include

      self
    end

    def add_includes(*includes)
      includes.each { |include| add_include(include) }

      self
    end

    def move_mode(value)
      @move_mode = value

      self
    end

    def move_mode?
      @move_mode ? true : false
    end

    private

    def clear_target
      target_remove(target_path)
      target_path.children.each { |tchild| target_remove(tchild) }
    end

    def copy
      source_path.children.each do |schild|
        ::FileUtils.cp_r(schild.to_path, target_path.to_path)
        schild.rmtree if move_mode?
      end
    end

    def source_to_target_path(source_path)
      source_path.relative_path_from(self.source_path).expand_path(target_path)
    end

    def target_remove(tpath)
      if tpath.directory?
        tpath.children.each { |tchild| target_remove(tchild) }
        tpath.rmdir if tpath.children.empty?
      elsif tpath.file? && !skip_target_path?(tpath)
        tpath.unlink
      end
    end

    def skip_target_path?(tpath)
      skip_path?(tpath.relative_path_from(target_path))
    end

    def skip_path?(relpath)
      relpath = relpath.expand_path('/')
      excludes.any? { |exclude| relpath.fnmatch?(exclude) } &&
        includes.none? { |include| relpath.fnmatch?(include) }
    end
  end
end
