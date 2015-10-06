require 'spec_helper'
require_relative '../../../../apps/web/controllers/posts/index'

describe Web::Controllers::Posts::Index do
  let(:action) { Web::Controllers::Posts::Index.new }
  let(:params) { Hash[] }

  before do
    PostRepository.clear

    @post         = PostRepository.create(Post.new(title: 'test post', content: '1'))
    @tagged_post  = PostRepository.create(Post.new(title: 'test post 2', content: '2'))
    @tagged_post.add_tag('test')
  end

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it 'exposes all posts' do
    action.call({})
    expect(action.exposures[:posts]).to eq([@tagged_post, @post])
  end

  it 'exposes all posts' do
    action.call({tag: 'test'})
    expect(action.exposures[:posts]).to eq([@tagged_post])
  end
end
