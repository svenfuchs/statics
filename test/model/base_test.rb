require File.expand_path('../../test_helper', __FILE__)

class ModelBaseTest < Test::Unit::TestCase
  def model(path)
   Slick::Model::Base.new(HOME_DIR + path)
  end

  def articles
    model('/articles.html')
  end

  test "slug is the underscored title (so it can be used in urls)" do
    assert_equal 'articles_page', articles.slug
  end

  test "title_from_path is the titleized filename's basename" do
    assert_equal 'Articles', articles.title_from_path
  end

  test "read adds the file's yaml preamble to the attributes" do
    assert_equal 'page', articles.layout
  end

  test "read stores the file's main content to the content attribute" do
    assert_equal 'Articles Page Content', articles.content
  end
end
