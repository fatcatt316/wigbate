class Comment < ActiveRecord::Base
  validates :post, presence: true
  validates :author, presence: true
  validates :body, presence: true

  belongs_to :post
end
