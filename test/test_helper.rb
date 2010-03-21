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
require 'Statics'
require File.expand_path('../test_declarative.rb', __FILE__)

ROOT_DIR  = File.expand_path('../_root', __FILE__)
DATA_DIR   = ROOT_DIR + '/data'
ASSETS_DIR = ROOT_DIR + '/assets'
PUBLIC_DIR = ROOT_DIR + '/public'
VIEWS_DIR  = ROOT_DIR + '/views'

Statics::Builder::Base.prepend_view_path(VIEWS_DIR)
