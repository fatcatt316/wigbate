class Post < ActiveRecord::Base
  mount_uploader :comic, ComicUploader

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :comic, presence: true

  has_many :comments, dependent: :destroy

  def self.random(exclude_id: nil)
    where.not(id: exclude_id).order('RANDOM()').first
  end
end
