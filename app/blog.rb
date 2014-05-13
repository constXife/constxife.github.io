class Blog < Sinatra::Base
  set :root, File.expand_path('../', __FILE__)
  set :public_folder, 'public'
  set :views, 'app/views'

  register Sinatra::AssetPipeline
  helpers BlogHelpers

  configure do
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
    I18n.backend.load_translations
  end

  configure :development do
    register Sinatra::Reloader
  end

  before do
    I18n.locale = :ru
  end

  get '/' do
    redirect '/blog/posts'
  end

  get '/blog/posts', :provides => 'html' do
    posts = Post.all
    haml 'posts/index'.to_sym, locals: {posts: posts}
  end

  get '/blog/posts/:title', :provides => 'html' do
    post = Post.find_by(title: params[:title])
    haml 'posts/show'.to_sym, locals: {post: post}
  end
end