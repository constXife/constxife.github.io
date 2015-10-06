require 'spec_helper'

RSpec.describe Post do
  let(:post) { Post.new(title: 'test') }

  it '#to_s' do
    expect(post.to_s).to eq('test')
  end
end
