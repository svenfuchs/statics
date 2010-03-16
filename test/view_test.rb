require File.expand_path('../test_helper', __FILE__)

class ViewTest < Test::Unit::TestCase
  test 'simple render' do
    section = Slick::Model::Blog.new('path/to/foo')
    section.attributes = {
      :title => 'da blog',
      # :children => [{ :title => 'a page'}],
      # :contents => [{ :title => 'a post' }]
    }
    html = ActionView::Base.new([VIEWS_DIR]).render(:file => 'blog/index', :locals => { :section => section })
    assert_match /#{section.title}/, html
  end
end

