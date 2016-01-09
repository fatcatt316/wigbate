class Post < ActiveRecord::Base
  validates :title, presence: true, uniqueness: { case_sensitive: false }

  has_many :comments, dependent: :destroy
end
