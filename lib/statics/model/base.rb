require 'pathname'
require 'active_support/core_ext/module/delegation'

module Statics::Model
  class Base
    YAML_PREAMBLE = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    attr_reader :path
    attr_writer :attributes

    delegate :basename, :extname, :file?, :directory?, :ctime, :mtime, :to => :path

    def initialize(path)
      @path = Pathname.new(path.to_s)
    end

    def attributes
      @attributes ||= read
    end

    def type
      attributes[:type] || 'page'
    end

    def layout
      attributes[:layout]
    end

    def template
      attributes[:template]
    end

    def slug
      basename.to_s.gsub(extname, '')
    end

    def dirname
      directory? ? path : Pathname.new(path.to_s.gsub(extname, ''))
    end

    alias :created_at :ctime
    alias :updated_at :mtime

    def published_at
      attributes.key?(:published_at) ? attributes[:published_at] : ctime
    end

    def respond_to?(name)
      attributes.key?(name)
    end

    def method_missing(name, *args, &block)
      respond_to?(name) ? attributes[name] : super
    end

    protected

      def read
        { :title => title_from_path }.tap do |attributes|
          attributes.merge!(parse(::File.read(path.to_s).strip)) if file?
        end
      end

      def title_from_path
        title = File.basename(path.to_s).gsub(extname, '').titleize
        title == 'Data' ? nil : title
      end

      def parse(body)
        parse_yaml_preamble(body).merge(:body => body)
      end

      def parse_yaml_preamble(body)
        body.gsub!(YAML_PREAMBLE, '')
        $1 ? YAML.load($1).symbolize_keys : {}
      end
  end
end
