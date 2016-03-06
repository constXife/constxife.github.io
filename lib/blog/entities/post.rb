class Post
  include Hanami::Entity
  attributes :title, :preview, :content, :slug, :created_at, :updated_at

  def to_s
    @title
  end

  def tag_list
    PostRepository.tag_list(@id)
  end

  def add_tag(*tag_names)
    tag_names.map {|tag_name| PostRepository.add_tag(@id, tag_name) }
  end
end
