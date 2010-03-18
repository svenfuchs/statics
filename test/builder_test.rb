require File.expand_path('../test_helper', __FILE__)
require 'fileutils'

class BuilderTest < Test::Unit::TestCase
  def setup
    @config  = {
      :root => TEST_ROOT
    }
    @section = Slick::Model::Section.new(DATA_DIR)
    # FileUtils.rm_r(PUBLIC_DIR) rescue Errno::ENOENT
    FileUtils.mkdir_p(PUBLIC_DIR)
  end

  test 'path for a root section is index' do
    root = Slick::Builder::Blog.new(:section => @section)
    assert_equal 'index', root.send(:path)
  end

  test 'path for a nested section is its section slug' do
    root = Slick::Builder::Blog.new(:section => @section)
    nested = Slick::Builder::Blog.new({ :section => @section.children.last }, root)
    assert_equal 'projects', nested.send(:path)
  end

  test "path for a nested nested section is its parent's section slug and sectin slug" do
    root = Slick::Builder::Blog.new(:section => @section)
    nested = Slick::Builder::Blog.new({ :section => @section.children.last }, root)
    nested_nested = Slick::Builder::Blog.new({ :section => @section.children.last }, nested)
    assert_equal 'projects/projects', nested_nested.send(:path)
  end

  test 'path for a root section article is its article slug' do
    root = Slick::Builder::Blog.new(:section => @section.children.last)
    nested = Slick::Builder::Blog.new({ :section => @section.children.last }, root)
    assert_equal 'projects', nested.send(:path)
  end

  test 'build' do
    Slick::Builder::Blog.new(:config => @config, :section => @section).build

    assert File.exists?(PUBLIC_DIR + '/index.html')
    assert File.exists?(PUBLIC_DIR + '/2009/07/06/using_ruby_1_9_ripper.html')
    assert File.exists?(PUBLIC_DIR + '/articles.html')
    assert File.exists?(PUBLIC_DIR + '/articles/articles_child.html')
    assert File.exists?(PUBLIC_DIR + '/projects.html')
    assert File.exists?(PUBLIC_DIR + '/projects/i18n.html')
    assert File.exists?(PUBLIC_DIR + '/contact.html')
  end

  test 'build w/ the application (default) layout' do
    @section.attributes['layout'] = 'does_not_exist'
    assert_match /application layout/, Slick::Builder.create(nil, @section, :section => @section).send(:build_index)
  end

  test 'build w/ a builder specific layout' do
    section = @section.children.detect { |child| child.layout == nil }
    assert_match /page layout/, Slick::Builder.create(nil, section, :section => section).send(:build_index)
  end

  test 'build w/ a custom layout' do
    section = @section.children.detect { |child| child.layout == 'custom' }
    assert_match /custom layout/, Slick::Builder.create(nil, section, :section => section).send(:build_index)
  end
end
