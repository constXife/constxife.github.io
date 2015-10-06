# encoding: utf-8

module Web::Controllers::Posts
  class Index
    include Web::Action

    expose :posts, :tag

    params do
      param :tag
    end

    def call(params)
      @tag = params[:tag].to_s.force_encoding(Encoding::UTF_8)
      filters = {}
      filters = {tag_name: @tag} unless @tag.empty?
      @posts = PostRepository.get_list(filters)
    end
  end
end
