Blog::Application.routes.draw do
  root 'application#index'

  scope '/blog' do
    resources :posts
    get '/posts/:year/:month/:title' => 'posts#show', as: :post_show
  end

  devise_for :users
end