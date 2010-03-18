require File.expand_path('../../test_helper', __FILE__)

class ModelSectionTest < Test::Unit::TestCase
  include Slick::Model

  test 'determine_type returns Page for a page file' do
    assert_equal 'page', Section.new(DATA_DIR + '/contact.html').send(:determine_type)
  end

  test 'determine_type returns Page for a page directory' do
    assert_equal 'page', Section.new(DATA_DIR + '/projects').send(:determine_type)
  end

  test 'determine_type returns Blog for a blog directory' do
    assert_equal 'blog', Section.new(DATA_DIR).send(:determine_type)
  end

  test 'building a Page from a page file' do
    model = Section.new(DATA_DIR + '/contact.html')
    assert_equal 'page', model.type
    assert_equal 'custom', model.layout
    assert_equal 'http://github.com/svenfuchs', model.body
  end

  test 'building a Page from a page directory' do
    model = Section.new(DATA_DIR + '/projects')
    assert_equal 'page', model.type
    assert_equal 'Projects', model.title

    assert_equal 1, model.children.size
    assert_equal 'I18n', model.children.first.title
  end

  test 'building a Page from a page directory and file' do
    model = Section.new(DATA_DIR + '/articles.html')
    assert_equal 'page', model.type
    assert_equal 'Articles', model.title

    assert_equal 1, model.children.size
    assert_equal 'Articles Child', model.children.first.title
  end

  test 'building a Blog from the home directory' do
    model = Section.new(DATA_DIR)
    assert_equal 'blog', model.type

    assert_equal 2, model.contents.size
    assert_equal 'Using Ruby 1.9 Ripper', model.contents.first.title
    assert_equal 'Ripper2Ruby: modify and recompile your Ruby code', model.contents.last.title

    assert_equal 3, model.children.size
    assert_equal 'Articles', model.children.first.title
    assert_equal 1, model.children.first.children.size
  end

  test 'child_paths does not contain both a section dir and a section file but skips the section dir' do
    paths = Section.new(DATA_DIR).send(:child_paths)
    assert paths.include?(DATA_DIR + '/projects')
    assert paths.include?(DATA_DIR + '/articles.html')
    assert !paths.include?(DATA_DIR + '/articles')
  end
end
