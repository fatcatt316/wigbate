class Post < ActiveRecord::Base
  mount_uploader :comic, ComicUploader

  after_create :set_slug

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :comic, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: false }, if: :persisted?

  has_many :comments, dependent: :destroy

  def self.random(exclude_id: nil)
    where.not(id: exclude_id).order('RANDOM()').first
  end

  def to_param
    slug
  end

  def previous
    self.class.order(id: :desc).where('id < ?', id).first
  end

  def next
    self.class.where('id > ?', id).first
  end

  private

  def set_slug
    if slug.blank?
      self.slug = "#{id}-#{title.parameterize}"
      self.save!
    end
  end
end
