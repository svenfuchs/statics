require File.expand_path('../../test_helper', __FILE__)

class ModelContentTest < Test::Unit::TestCase
  def content
  end

  test "published_at_from_file_name parses a date from the file's basename" do
    content = Slick::Model::Content.new(DATA_DIR + '/_posts/2009-07-05-foo.html')
    date = content.send(:published_at_from_filename)
    assert_equal '2009-07-05', date.to_s
  end
end
