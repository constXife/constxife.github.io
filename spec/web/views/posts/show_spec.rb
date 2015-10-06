require 'spec_helper'
require_relative '../../../../apps/web/views/posts/show'

describe Web::Views::Posts::Show do
  let(:template)  { Lotus::View::Template.new('apps/web/templates/posts/show.html.haml') }
  let(:view)      { Web::Views::Posts::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  before do
    PostRepository.clear
  end

  context 'when there are no post' do
    let(:exposures) { Hash[post: nil] }

    it 'show a placeholder message' do
      expect(rendered).to have_content('Такого поста нет.')
    end
  end

  context 'when there post exists' do
    let(:post) { PostRepository.create(Post.new(title: 'test post', content: '1', slug: 'test-post')) }
    let(:exposures) { Hash[post: post] }

    it 'list them all' do
      expect(rendered.scan(/class='post'/).count).to eq(1)
      expect(rendered).to have_content('test post')
    end

    it 'hides a placeholder message' do
      expect(view.render).not_to have_content('Такого поста нет.')
    end
  end
end
