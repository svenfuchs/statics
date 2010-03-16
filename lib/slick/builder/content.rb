require 'fileutils'

module Slick::Builder
  class Content
    def view
      @@view ||= ActionView::Base.new([File.expand_path('../../views', __FILE__)])
    end

    def document_root
      @@document_root ||= File.expand_path('../../../../public', __FILE__)
    end

    def write(file_name, html)
      path = [document_root, path, file_name].compact.join('/')
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w+') { |f| f.write(html) }
    end
  end
end

