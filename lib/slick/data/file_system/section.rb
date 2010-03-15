module Slick::Data::FileSystem
  class Section < Content
    TYPES = {
      '_articles' => Page,
      '_posts'    => Blog
    }

    class << self
      def build_from(path)
        section = determine_type(path).new(path)
      end

      def determine_type(path)
        subdirs = Dir["#{path}/_*"].map { |path| File.basename(path) }
        subdirs.each { |subdir| type = TYPES[subdir] and return type }
        Page
      end
    end

    def read
      data = super
      data[:type] = type
      data[:contents] = build_contents if type_dir? # would happen in Blog and Page
      data[:children] = build_children if directory?
      data
    end

    def type
      self.class.name.split('::').last.underscore
    end

    def type_dir
      directory? && (subdir = TYPES.invert[self.class]) ? directory + '/' + subdir : nil
    end

    def type_dir?
      type_dir && File.directory?(type_dir)
    end

    def build_contents
      Dir["#{type_dir}/**/*"].map { |path| Content.new(path).read }
    end

    def build_children
      child_paths.map { |path| Section.build_from(path).read }
    end

    def child_paths
      paths = Dir["#{directory}/[^_]*"].sort.reverse
      paths.inject([paths.shift]) do |paths, path|
        # i.e. skip articles/ if we already have articles.html
        paths.unshift path unless paths.first == path + File.extname(paths.first)
        paths
      end
    end
  end
end
