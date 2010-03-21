require 'active_support/core_ext/object/singleton_class'
require 'action_view'

module Statics
  autoload :Builder, 'Statics/builder'
  autoload :Data,    'Statics/data'
  autoload :Model,   'Statics/model'
end
