require 'yaml'
require 'core_ext/hash/symbolize_keys'
require 'core_ext/string/titleize'

module Slick::Model
  class Content < Base
    PUBLISHED_AT_PATTERN = %r((?:^|\/)([\d]{4}[-_][\d]{1,2}[-_][\d]{1,2})[-_])

    def permalink
      date = published_at.to_s.gsub('-', '/')
      [date, slug].join('/')
    end

    def slug
      super.gsub(PUBLISHED_AT_PATTERN, '')
    end

    protected

      def read
        attributes = super
        attributes.merge!(:published_at => published_at_from_filename) unless attributes.key?(:published_at)
        attributes
      end

      # should overwrite and strip the date
      # def title_from_path
      #   title = File.basename(path.to_s).gsub(extname, '').titleize
      #   title == 'Data' ? nil : title
      # end

      def published_at_from_filename
        basename.to_s =~ PUBLISHED_AT_PATTERN
        Date.parse($1) rescue nil
      end
  end
end
