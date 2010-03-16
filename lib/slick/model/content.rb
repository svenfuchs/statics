require 'yaml'
require 'core_ext/hash/symbolize_keys'
require 'core_ext/string/titleize'

module Slick::Model
  class Content < Base
    def permalink # TODO
      date = published_at
      slug = title.underscore.gsub(/[\W]/, '_')
      [date.year, date.month, date.day, slug].join('/')
    end
  end
end


