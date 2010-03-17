require 'core_ext/string/camelize'

module Slick::Model
  autoload :Base,    'slick/model/base'
  autoload :Blog,    'slick/model/blog'
  autoload :Content, 'slick/model/content'
  autoload :Page,    'slick/model/page'
  autoload :Section, 'slick/model/section'
  autoload :Site,    'slick/model/site'
end
