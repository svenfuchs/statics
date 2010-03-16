module Slick::Builder
  autoload :Blog,    'slick/builder/blog'
  autoload :Content, 'slick/builder/content'
  autoload :Page,    'slick/builder/page'
  autoload :Section, 'slick/builder/section'

  class << self
    def create(parent, object, data)
      const_get(object.class.name.split('::').last).new(data, parent)
    end
  end
end
