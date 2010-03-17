require 'yaml'
require 'core_ext/hash/symbolize_keys'
require 'core_ext/string/titleize'

module Slick::Model
  class Content < Base
    PUBLISHED_AT_PATTERN = %r((?:^|\/)([\d]{4}[-_][\d]{2}[-_][\d]{2}))

    def permalink # TODO
      date = published_at
      slug = title.underscore.gsub(/[\W]/, '_')
      [date.year, date.month, date.day, slug].join('/')
    end

    protected

      def read
        attributes = super
        attributes.merge(:published_at => published_at_from_filename) unless attributes.key?(:published_at)
        attributes
      end

      def published_at_from_filename
        basename.to_s =~ PUBLISHED_AT_PATTERN
        Date.parse($1) rescue nil
      end
  end
end
