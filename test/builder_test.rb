require File.expand_path('../test_helper', __FILE__)

class BuilderTest < Test::Unit::TestCase
  def setup
    @section = Slick::Model.build(HOME_DIR)
  end

  test 'path for a root section is index' do
    root = Slick::Builder::Blog.new(:section => @section)
    assert_equal 'index', root.path
  end

  test 'path for a nested section is its section slug' do
    root = Slick::Builder::Blog.new(:section => @section)
    nested = Slick::Builder::Blog.new({ :section => @section.children.last }, root)
    assert_equal 'projects', nested.path
  end

  test "path for a nested nested section is its parent's section slug and sectin slug" do
    root = Slick::Builder::Blog.new(:section => @section)
    nested = Slick::Builder::Blog.new({ :section => @section.children.last }, root)
    nested_nested = Slick::Builder::Blog.new({ :section => @section.children.last }, nested)
    assert_equal 'projects/projects', nested_nested.path
  end

  test 'path for a root section article is its article slug' do
    root = Slick::Builder::Blog.new(:section => @section.children.last)
    nested = Slick::Builder::Blog.new({ :section => @section.children.last }, root)
    assert_equal 'projects', nested.path
  end

  # test 'foo' do
  #   root = Slick::Builder::Blog.new(:section => @section)
  #   root.build
  # end
end
