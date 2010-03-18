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

    attr_reader :config

    def initialize(data, parent = nil)
      @parent = parent
      @data   = data
      @config = ActiveSupport::InheritableOptions.new(data[:config] || {})
    end

    def local_path(content)
      content.path.to_s.gsub("#{config.root_dir}/public", '')
    end
    helper_method :local_path

    protected

      def render(template, target)
        html = super(:template => template, :layout => layout, :locals => data)
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
