require 'yaml'
require 'slick/core_ext/hash/symbolize_keys'
require 'slick/core_ext/string/titleize'

module Slick::Data::FileSystem
  class Content < Path
    YAML_PREAMBLE = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    def title_from_path
      title = basename.gsub(extname, '').titleize
    end

    def read
      super.merge(file? ? parse(::File.read(path).strip) : {})
    end

    def parse(content)
      parse_yaml_preamble(content).merge(:content => content)
    end

    def parse_yaml_preamble(content)
      content.gsub!(YAML_PREAMBLE, '')
      $1 ? YAML.load($1).symbolize_keys : {}
    end
  end
end


