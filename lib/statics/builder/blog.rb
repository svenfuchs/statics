module Statics::Builder
  class Blog < Section
    def build
      super
      build_posts
      build_feed
      build_archive
    end

    protected

      def build_posts
        section.contents.each do |content|
          data.merge!(:content => content)
          render("#{section.type}/show", "#{content.permalink}.html")
        end
      end

      def build_feed
        # TODO curiously rails would not find the template if named index.atom.builder
        render("#{section.type}/feed", "#{path}.atom", :format => :atom)
      end

      def build_archive
        render("#{section.type}/archive", "#{File.dirname(path)}/archive.html")
      end
  end
end

