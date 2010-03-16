require 'core_ext/string/camelize'

module Slick::Model
  autoload :Base,    'slick/model/base'
  autoload :Blog,    'slick/model/blog'
  autoload :Content, 'slick/model/content'
  autoload :Page,    'slick/model/page'
  autoload :Section, 'slick/model/section'
  autoload :Site,    'slick/model/site'

  TYPES = {
    '_articles' => Page,
    '_posts'    => Blog
  }

  class << self
    def build(path)
      determine_type(path).new(path)
    end

    def determine_type(path)
      subdirs = Dir["#{path}/_*"].map { |path| File.basename(path) }
      subdirs.each { |subdir| type = TYPES[subdir] and return type }
      Page
    end
  end
end
