require File.expand_path('../test_helper', __FILE__)

class ModelTest < Test::Unit::TestCase
  include Slick

  test 'determine_type returns Page for a page file' do
    assert_equal Model::Page, Model.determine_type(HOME_DIR + '/contact.html')
  end

  test 'determine_type returns Page for a page directory' do
    assert_equal Model::Page, Model.determine_type(HOME_DIR + '/projects')
  end

  test 'determine_type returns Blog for a blog directory' do
    assert_equal Model::Blog, Model.determine_type(HOME_DIR)
  end

  test 'building a Page from a page file' do
    model = Model.build(HOME_DIR + '/contact.html')
    assert_equal 'page', model.type
    assert_equal 'page', model.layout
    assert_equal 'http://github.com/svenfuchs', model.content
  end

  test 'building a Page from a page directory' do
    model = Model.build(HOME_DIR + '/projects')
    assert_equal 'page', model.type
    assert_equal 'Projects', model.title

    assert_equal 1, model.children.size
    assert_equal 'Project I18n', model.children.first.title
  end

  test 'building a Page from a page directory and file' do
    model = Model.build(HOME_DIR + '/articles.html')
    assert_equal 'page', model.type
    assert_equal 'Articles Page', model.title

    assert_equal 1, model.contents.size
    assert_equal 'Article 1', model.contents.first.title

    assert_equal 1, model.children.size
    assert_equal 'Articles Child Page', model.children.first.title
  end

  test 'building a Blog from the home directory' do
    model = Model.build(HOME_DIR)
    assert_equal 'blog', model.type

    assert_equal 2, model.contents.size
    assert_equal 'Ripper2Ruby: modify and recompile your Ruby code', model.contents.first.title

    assert_equal 3, model.children.size
    assert_equal 'Articles Page', model.children.first.title
    assert_equal 1, model.children.first.children.size
  end
end
