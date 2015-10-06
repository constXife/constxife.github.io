require 'spec_helper'
require_relative '../../../../apps/web/views/posts/index'

describe Web::Views::Posts::Index do
  let(:template)  { Lotus::View::Template.new('apps/web/templates/posts/index.html.haml') }
  let(:view)      { Web::Views::Posts::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  before do
    PostRepository.clear
    PostRepository.tags_reset!
  end

  context 'when there are no posts' do
    let(:exposures) { Hash[posts: [], tag: ''] }

    it 'show a placeholder message' do
      expect(rendered).to have_content('Здесь пока пусто.')
    end
  end

  context 'when there are posts' do
    let(:post) { PostRepository.create(Post.new(title: 'test post', content: '1')) }
    let(:exposures) { Hash[posts: [post], tag: ''] }

    it 'list them all' do
      expect(rendered.scan(/class='posts'/).count).to eq(1)
      expect(rendered).to have_content('test post')
    end

    it 'hides a placeholder message' do
      expect(view.render).not_to have_content('Здесь пока пусто.')
    end
  end
end
