require 'features_helper'

describe 'Visit posts' do
  before do
    PostRepository.clear

    PostRepository.create(Post.new(
      title: 'test post',
      content: 'test content'
    ))
  end

  it 'is successfull' do
    visit '/blog/posts'
    within('.posts') do
      expect(page.body).to have_content 'test post'
    end
  end
end
