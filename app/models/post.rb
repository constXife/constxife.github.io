# Class for posts blog
class Post < ActiveRecord::Base
  def to_s
    self.title
  end
end