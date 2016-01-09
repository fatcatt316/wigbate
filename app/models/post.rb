class Post < ActiveRecord::Base
  validates :title, presence: true, uniqueness: { case_sensitive: false }

  has_many :comments, dependent: :destroy

  def self.random(exclude_id: nil)
    where.not(id: exclude_id).order('RANDOM()').first
  end
end
