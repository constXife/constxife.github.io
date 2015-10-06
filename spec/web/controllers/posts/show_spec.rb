require 'spec_helper'
require_relative '../../../../apps/web/controllers/posts/show'

describe Web::Controllers::Posts::Show do
  let(:action) { Web::Controllers::Posts::Show.new }
  let(:params) { Hash[title: 'test-post'] }

  before do
    PostRepository.clear

    @post = PostRepository.create(Post.new(title: 'test post', slug: 'test-post', content: '1'))
  end

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it 'it not found' do
    response = action.call(Hash[title: 'zzz'])
    expect(response[0]).to eq 404
  end
end
