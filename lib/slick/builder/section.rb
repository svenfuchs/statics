module Slick::Builder
  class Section < Content
    attr_reader :data, :site, :section, :parent

    def initialize(data, parent = nil)
      @parent = parent
      @data = data
      @site, @section = data.values_at(:site, :section)
    end

    def root?
      parent.nil?
    end

    def path # TODO should be in the model, we don't have routing, so keep it simple
      root? ? 'index' : [parent.root? ? nil : parent.path, section.slug].compact.join('/')
    end

    def build
      render_index
      section.contents.each { |content| render_content(content) }
      section.children.each { |child| Slick::Builder.create(self, child, data.merge(:section => child)).build }
    end

    def render_index
      write("#{path}.html", render('index', data))
    end

    def render_content(content)
      write("#{content.permalink}.html", render('show', data.merge(:content => content)))
    end

    def render(template, locals)
      view.render(:file => "#{section.type}/#{template}", :locals => locals)
    end
  end
end

