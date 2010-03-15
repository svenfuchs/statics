require File.expand_path('../test_helper', __FILE__)

HOME_DIR = File.expand_path('../fixtures/home', __FILE__)

class FileSystemTest < Test::Unit::TestCase
  FileSystem = Slick::Data::FileSystem

  test 'determine_type returns Slick::Page for a page file' do
    assert_equal FileSystem::Page, FileSystem::Section.determine_type(HOME_DIR + '/contact.html')
  end

  test 'determine_type returns Slick::Page for a page directory' do
    assert_equal FileSystem::Page, FileSystem::Section.determine_type(HOME_DIR + '/projects')
  end

  test 'determine_type returns Slick::Blog for a blog directory' do
    assert_equal FileSystem::Blog, FileSystem::Section.determine_type(HOME_DIR)
  end

  test 'child_paths does not contain both a section dir and a section file but skips the section dir' do
    assert FileSystem::Section.new(HOME_DIR).child_paths.include?(HOME_DIR + '/articles.html')
    assert FileSystem::Section.new(HOME_DIR).child_paths.include?(HOME_DIR + '/projects')
    assert !FileSystem::Section.new(HOME_DIR).child_paths.include?(HOME_DIR + '/articles')
  end

  test 'building a Page from a page file' do
    data = FileSystem::Section.build_from(HOME_DIR + '/contact.html').read
    assert_equal 'page', data[:type]
    assert_equal 'page', data[:layout]
    assert_equal 'http://github.com/svenfuchs', data[:content]
  end

  test 'building a Page from a page directory' do
    data = FileSystem::Section.build_from(HOME_DIR + '/projects').read
    assert_equal 'page', data[:type]
    assert_equal 'Projects', data[:title]

    assert_equal 1, data[:children].size
    assert_equal 'Project I18n', data[:children].first[:title]
  end

  test 'building a Page from a page directory and file' do
    data = FileSystem::Section.build_from(HOME_DIR + '/articles.html').read
    assert_equal 'page', data[:type]
    assert_equal 'Articles List Page', data[:title]

    assert_equal 1, data[:contents].size
    assert_equal 'Article 1', data[:contents].first[:title]

    assert_equal 1, data[:children].size
    assert_equal 'Articles List Child Page', data[:children].first[:title]
  end

  test 'building a Blog from the home directory' do
    data = FileSystem::Section.build_from(HOME_DIR).read
    assert_equal 'blog', data[:type]

    assert_equal 2, data[:contents].size
    assert_equal 'Ripper2Ruby: modify and recompile your Ruby code', data[:contents].first[:title]

    assert_equal 3, data[:children].size
    assert_equal 'Articles List Page', data[:children].first[:title]
    assert_equal 1, data[:children].first[:children].size
  end
end
