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

    protected

      def document_root
        @@document_root ||= File.expand_path('../../../../public', __FILE__)
      end

      def render(template, target)
        write(target, super(:template => template, :layout => layout, :locals => data))
      end

      def write(file_name, html)
        path = [document_root, path, file_name].compact.join('/')
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w+') { |f| f.write(html) }
      end

    public

      # TODO can this be made smarter in AbstractController::Layouts? doesn't even seem to be used anywhere?
      def config
        {}
      end

      # TODO can this be made smarter in AbstractController::Layouts? just pass it through for now
      def response_body=(body)
        body
      end
  end
end

