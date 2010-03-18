require File.expand_path('../../test_helper', __FILE__)

class ModelBaseTest < Test::Unit::TestCase
  def model(path)
   Slick::Model::Base.new(path)
  end

  test "slug is the underscored title (so it can be used in urls)" do
    model = self.model(DATA_DIR + '/articles_page_foo_bar')
    model.attributes[:title] = 'Articles Page foo Bar'
    assert_equal 'articles_page_foo_bar', model.slug
  end

  test "title_from_path is the titleized filename's basename" do
    model = self.model(DATA_DIR + '/articles_page_foo_bar')
    assert_equal 'Articles Page Foo Bar', model.send(:title_from_path)
  end

  test "read adds the file's yaml preamble to the attributes" do
    model = self.model(DATA_DIR + '/articles.html')
    assert_equal 'page', model.layout
  end

  test "read stores the file's main content to the content attribute" do
    model = self.model(DATA_DIR + '/articles.html')
    assert_equal 'Articles Content', model.content
  end
end
