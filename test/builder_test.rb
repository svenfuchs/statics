require File.expand_path('../test_helper', __FILE__)
require 'fileutils'

class BuilderTest < Test::Unit::TestCase
  def setup
    @config  = {
      :title           => "Sven Fuchs",
      :url             => "http://svenfuchs.com",
      :author          => "Sven Fuchs",
      :root_dir        => ROOT_DIR,
      :assets_dir      => PUBLIC_DIR,
      :stylesheets_dir => PUBLIC_DIR + '/stylesheets',
      :javascripts_dir => PUBLIC_DIR + '/javascripts'
    
    }
    @section = Statics::Model::Section.new(DATA_DIR)
    FileUtils.rm_r(PUBLIC_DIR) rescue Errno::ENOENT
    FileUtils.mkdir_p(PUBLIC_DIR)
  end

  test 'path for a root section is index' do
    root = Statics::Builder::Blog.new(:section => @section)
    assert_equal 'index', root.send(:path)
  end

  test 'path for a nested section is its section slug' do
    root = Statics::Builder::Blog.new(:section => @section)
    nested = Statics::Builder::Blog.new({ :section => @section.children.last }, root)
    assert_equal 'projects', nested.send(:path)
  end

  test "path for a nested nested section is its parent's section slug and sectin slug" do
    root = Statics::Builder::Blog.new(:section => @section)
    nested = Statics::Builder::Blog.new({ :section => @section.children.last }, root)
    nested_nested = Statics::Builder::Blog.new({ :section => @section.children.last }, nested)
    assert_equal 'projects/projects', nested_nested.send(:path)
  end

  test 'path for a root section article is its article slug' do
    root = Statics::Builder::Blog.new(:section => @section.children.last)
    nested = Statics::Builder::Blog.new({ :section => @section.children.last }, root)
    assert_equal 'projects', nested.send(:path)
  end

  test 'build' do
    Statics::Builder::Blog.new(:config => @config, :section => @section).build

    assert File.exists?(PUBLIC_DIR + '/index.html')
    assert File.exists?(PUBLIC_DIR + '/2009/07/06/using-ruby-1-9-ripper.html')
    assert File.exists?(PUBLIC_DIR + '/articles.html')
    assert File.exists?(PUBLIC_DIR + '/articles/child.html')
    assert File.exists?(PUBLIC_DIR + '/projects.html')
    assert File.exists?(PUBLIC_DIR + '/projects/i18n.html')
    assert File.exists?(PUBLIC_DIR + '/contact.html')
  end

  test 'build w/ the application (default) layout' do
    @section.attributes['layout'] = 'does_not_exist'
    assert_match /DOCTYPE html/, Statics::Builder.create(nil, @section, :config => @config, :section => @section).send(:build_index)
  end

  test 'build w/ a builder specific layout' do
    section = @section.children.detect { |child| child.layout == nil }
    assert_match /page layout/, Statics::Builder.create(nil, section, :config => @config, :section => section).send(:build_index)
  end

  test 'build w/ a custom layout' do
    section = @section.children.detect { |child| child.layout == 'custom' }
    assert_match /custom layout/, Statics::Builder.create(nil, section, :config => @config, :section => section).send(:build_index)
  end

  test 'build w/ a custom template' do
    section = @section.children.detect { |child| child.template == 'custom' }
    assert_match /custom template/, Statics::Builder.create(nil, section, :config => @config, :section => section).send(:build_index)
  end

  test 'build w/ an overwritten page template' do
    section = @section.children.detect { |child| child.title == 'Contact' }
    assert_match /Custom Page/, Statics::Builder.create(nil, section, :config => @config, :section => section).send(:build_index)
  end
end
