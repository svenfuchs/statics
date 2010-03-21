require 'core_ext/string/camelize'

module Statics::Model
  autoload :Base,    'Statics/model/base'
  autoload :Blog,    'Statics/model/blog'
  autoload :Content, 'Statics/model/content'
  autoload :Page,    'Statics/model/page'
  autoload :Section, 'Statics/model/section'
  autoload :Site,    'Statics/model/site'
end
