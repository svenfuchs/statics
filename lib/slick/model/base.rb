require 'pathname'

module Slick::Model
  class Base < Pathname
    YAML_PREAMBLE = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    attr_writer :attributes

    def attributes
      @attributes ||= read
    end

    def type
      self.class.name.split('::').last.underscore
    end

    def slug # TODO
      title.underscore.gsub(/[\W]/, '_')
    end

    def title_from_path
      title = File.basename(self.to_s).gsub(extname, '').titleize
    end

    def dirname
      directory? ? self : Pathname.new(self.to_s.gsub(extname, ''))
    end

    alias :created_at :ctime
    alias :updated_at :mtime

    def published_at
      attributes.key?(:published_at) ? attributes[:published_at] : ctime
    end

    def read
      attributes = { :title => title_from_path }
      attributes.merge!(parse(::File.read(self.to_s).strip)) if file?
      attributes
    end

    def parse(content)
      parse_yaml_preamble(content).merge(:content => content)
    end

    def parse_yaml_preamble(content)
      content.gsub!(YAML_PREAMBLE, '')
      $1 ? YAML.load($1).symbolize_keys : {}
    end

    def respond_to?(name)
      attributes.key?(name)
    end

    def method_missing(name, *args, &block)
      respond_to?(name) ? attributes[name] : super
    end

    def inspect
      super.gsub(/>/, " #{attributes.inspect}")
    end
  end
end
