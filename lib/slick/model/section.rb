module Slick::Model
  class Section < Base
    attr_reader :children, :contents

    def initialize(path)
      super
    end

    def type_dir?
      type_dir && File.directory?(type_dir)
    end

    def type_dir
      (subdir = TYPES.invert[self.class]) ? dirname + subdir : nil
    end

    def contents
      @contents ||= Dir["#{type_dir}/**/*"].map { |path| Content.new(path) } if type_dir?
    end

    def children
      @children ||= child_paths.map { |path| Slick::Model.build(path) }
    end

    def child_paths
      paths = Dir["#{dirname}/[^_]*"].sort.reverse
      paths.empty? ? [] : paths.inject([paths.shift]) do |paths, path|
        # i.e. skip articles/ if we already have articles.html
        paths.unshift path unless paths.first == path + File.extname(paths.first)
        paths
      end
    end
  end
end


