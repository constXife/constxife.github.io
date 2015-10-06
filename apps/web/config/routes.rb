redirect '/',     to: '/blog/posts'
redirect '/blog', to: '/blog/posts'

get '/blog/posts',    to: Web::Controllers::Posts::Index
get '/blog/tag/:tag', to: Web::Controllers::Posts::Index, as: :tag
get '/blog/posts/:year/:month/:title', to: Web::Controllers::Posts::Show, as: :post_show
