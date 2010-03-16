$: << File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'pp'
require 'slick'
require File.expand_path('../test_declarative.rb', __FILE__)

HOME_DIR  = File.expand_path('../fixtures/home', __FILE__)
VIEWS_DIR = File.expand_path('../../lib/slick/views', __FILE__)
