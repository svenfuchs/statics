require 'fileutils'
require 'abstract_controller'

module Slick::Builder
  class Base
    class << self
      def controller_path
        name.split('::').last.underscore
      end
    end

    include AbstractController::Layouts

    self.view_paths = [File.expand_path('../../views', __FILE__)]
    self.layout 'application'

    attr_reader :config

    def initialize(data, parent = nil)
      @parent = parent
      @data   = data
      @config = data[:config] || {}
    end

    protected

      def root_dir
        @config[:root] ||= File.expand_path('../../../..', __FILE__)
      end

      def public_dir
        "#{root_dir}/public"
      end

      def view_paths
        p "KEKSE"
      end

      def render(template, target)
        html = super(:template => template, :layout => layout, :locals => data)
        write(target, html) && html
      end

      def write(file_name, html)
        path = [public_dir, path, file_name].compact.join('/')
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(html) }
      end

    public

      # TODO can this be made smarter in AbstractController::Layouts? doesn't even seem to be used anywhere?
      # def config
      #   {}
      # end

      # TODO can this be made smarter in AbstractController::Layouts? just pass it through for now
      def response_body=(body)
        body
      end
  end
end

