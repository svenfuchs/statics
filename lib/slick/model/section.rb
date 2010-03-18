module Slick::Model
  class Section < Base
    def initialize(path)
      super
    end

    def contents
      @contents ||= type == 'blog' ? build_posts : []
    end

    def children
      @children ||= child_paths.map { |path| Section.new(path) }
    end

    def read
      super.merge(:type => determine_type)
    end

    protected

      def build_posts
        build_contents.sort { |lft, rgt| rgt.published_at <=> lft.published_at }
      end

      def build_contents
        content_paths.map { |path| Content.new(path) }
      end

      def content_paths
        @content_paths ||= Dir["#{dirname.to_s}/*"].select { |path| path =~ Content::PUBLISHED_AT_PATTERN }
      end

      def child_paths
        (Dir["#{dirname}/[^_]*"].sort.reverse - content_paths).inject([]) do |paths, path|
          paths.unshift(path) unless paths.first && paths.first == path + File.extname(paths.first)
          paths
        end.compact
      end

      def determine_type
        Dir["#{dirname.to_s}/*"].any? { |path| path =~ Content::PUBLISHED_AT_PATTERN } ? 'blog' : 'page'
      end
  end
end


