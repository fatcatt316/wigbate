class Comment < ActiveRecord::Base
  validates :post, presence: true
  validates :author, presence: { message: 'has to be filled in!' }
  validates :body, presence: { message: "can't just be blank."}

  belongs_to :post

  scope :saved, -> { where.not(created_at: nil) }
end
