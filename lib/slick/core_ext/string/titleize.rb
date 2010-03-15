require 'slick/core_ext/string/humanize'
require 'slick/core_ext/string/underscore'

class String
  def titleize
    underscore.humanize.gsub(/\b('?[a-z])/) { $1.capitalize }
  end
end unless ''.respond_to?(:titleize)

