require 'fileutils'
require 'logger'
require 'abstract_controller'

module Slick::Builder
  class Base
    class << self
      def controller_path
        name.split('::').last.underscore
      end
    end

    include AbstractController::Layouts
    include AbstractController::Helpers

    self.view_paths = [File.expand_path('../../views', __FILE__)]
    self.layout 'application'

    attr_reader :config, :request
    helper_method :local_path, :url, :page_title, :request

    def initialize(data, parent = nil)
      @parent  = parent
      @data    = data
      @config  = ActiveSupport::InheritableOptions.new(data[:config] || {})
      @request = ActionDispatch::Request.new({ 'HTTP_HOST' => 'svenfuchs.com' })
    end

    def url(content)
      config[:url] + '/' + local_path(content)
    end

    def local_path(content)
      "#{content.permalink}.html" # TODO
    end

    def page_title
      content = data[:content] || section
      [content.title, config[:title]].compact.join(' - ')
    end

    protected

      def render(template, target, options = {})
        # TODO lookup_context, at least formats, seem messed up after we've rendered once
        @lookup_context = ActionView::LookupContext.new(self.class._view_paths, details_for_lookup)
        html = super(options.merge(:template => template, :layout => layout, :locals => data))
        write(target, html) && html
      end

      def write(file_name, html)
        path = [config.root_dir, 'public', path, file_name].compact.join('/')
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(html) }
      end

    public

      # TODO can this be made smarter in AbstractController::Layouts? just pass it through for now
      def response_body=(body)
        body
      end

      # TODO can this be just be a default in ActionView if !controller.respond_to?(:logger)
      def logger
        @logger ||= Logger.new(STDOUT)
      end
  end
end
