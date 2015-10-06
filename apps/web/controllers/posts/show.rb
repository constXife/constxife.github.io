# encoding: utf-8

module Web::Controllers::Posts
  class Show
    include Web::Action

    expose :post

    params do
      param :title
    end

    def call(params)
      @post = PostRepository.find_by_slug(params[:title])

      status 404, 'Такого поста нет.' unless @post
    end
  end
end
