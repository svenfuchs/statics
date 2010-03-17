module Slick::Builder
  class Section < Base
    attr_reader :data, :site, :section, :parent

    def initialize(data, parent = nil)
      @parent = parent
      @data = data
      @site, @section = data.values_at(:site, :section)
    end

    def build
      build_index
      build_children
    end

    protected

      def build_index
        render("#{section.type}/index", "#{path}.html")
      end

      def build_children
        section.children.each { |child| Slick::Builder.create(self, child, data.merge(:section => child)).build }
      end

      def root?
        parent.nil?
      end

      def path # TODO should be in the model, we don't have routing, so keep it simple
        root? ? 'index' : [parent.root? ? nil : parent.path, section.slug].compact.join('/')
      end

      def layout
        section.layout || :default
      end
  end
end

