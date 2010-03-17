$: << File.expand_path('../../lib', __FILE__)

require 'bundler'
Bundler.setup

require 'test/unit'
require 'pp'
require 'slick'
require File.expand_path('../test_declarative.rb', __FILE__)

HOME_DIR   = File.expand_path('../fixtures/home', __FILE__)
VIEWS_DIR  = File.expand_path('../../lib/slick/views', __FILE__)
PUBLIC_DIR = File.expand_path('../../public', __FILE__) # TODO move to config
