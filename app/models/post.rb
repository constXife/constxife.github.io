class Post < ActiveRecord::Base
  default_scope order(:created_at => :desc)
  paginates_per 10
  extend FriendlyId
  friendly_id :title, use: :slugged

  def to_s
    self.title
  end

  def year
    created_at.year
  end

  def month
    created_at.strftime('%m')
  end
end
