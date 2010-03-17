require File.expand_path('../test_helper', __FILE__)
require 'fileutils'

class BuilderTest < Test::Unit::TestCase
  def setup
    @section = Slick::Model::Section.new(HOME_DIR)
    FileUtils.mkdir_p(PUBLIC_DIR)
  end

  def teardown
    # FileUtils.rm_r(PUBLIC_DIR) rescue Errno::ENOENT
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

  test 'foo' do
    root = Slick::Builder::Blog.new(:section => @section)
    root.build
    assert File.exists?(PUBLIC_DIR + '/index.html')
    assert File.exists?(PUBLIC_DIR + '/articles.html')
    assert File.exists?(PUBLIC_DIR + '/articles/articles_child.html')
    # assert File.exists?(PUBLIC_DIR + '/articles/article_1.html')
    assert File.exists?(PUBLIC_DIR + '/projects.html')
    assert File.exists?(PUBLIC_DIR + '/projects/i18n.html')
    assert File.exists?(PUBLIC_DIR + '/contact.html')
  end
end
