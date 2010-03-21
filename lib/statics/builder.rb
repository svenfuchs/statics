module Statics::Builder
  autoload :Base,    'Statics/builder/base'
  autoload :Blog,    'Statics/builder/blog'
  autoload :Content, 'Statics/builder/content'
  autoload :Page,    'Statics/builder/page'
  autoload :Section, 'Statics/builder/section'

  class << self
    def create(parent, object, data)
      const_get(object.type.camelize).new(data, parent)
    end
  end
end
