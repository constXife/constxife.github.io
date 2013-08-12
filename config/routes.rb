Blog::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  root 'application#index'

  scope '/blog' do
    resources :posts
    get '/posts/:year/:month/:title' => 'posts#show', as: :post_show
    get '/tag/:tag' => 'posts#index', as: :tag
    get '/tags' => 'posts#tags', as: :tags
  end

  devise_for :users
end