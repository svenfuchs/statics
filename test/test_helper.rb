$: << File.expand_path('../../lib', __FILE__)
begin
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require 'test/unit'
require 'pp'
require 'slick'
require File.expand_path('../test_declarative.rb', __FILE__)

TEST_ROOT  = File.expand_path('../_root', __FILE__)
DATA_DIR   = TEST_ROOT + '/data'
ASSETS_DIR = TEST_ROOT + '/assets'
PUBLIC_DIR = TEST_ROOT + '/public'
VIEWS_DIR  = TEST_ROOT + '/views'

Slick::Builder::Base.prepend_view_path(VIEWS_DIR)
