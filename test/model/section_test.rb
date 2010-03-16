require File.expand_path('../../test_helper', __FILE__)

class ModelSectionTest < Test::Unit::TestCase
  include Slick

  test 'child_paths does not contain both a section dir and a section file but skips the section dir' do
    assert Model.build(HOME_DIR).child_paths.include?(HOME_DIR + '/articles.html')
    assert Model.build(HOME_DIR).child_paths.include?(HOME_DIR + '/projects')
    assert !Model.build(HOME_DIR).child_paths.include?(HOME_DIR + '/articles')
  end
end
