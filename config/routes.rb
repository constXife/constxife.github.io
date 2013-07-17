Blog::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'
  root 'application#index'

  scope '/blog' do
    resources :posts
    get '/posts/:year/:month/:title' => 'posts#show', as: :post_show
  end

  devise_for :users
end