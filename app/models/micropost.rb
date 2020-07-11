class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_length}
  validates :image, content_type: { in: Settings.micropost.content_type,
    message: I18n.t("must_image_format") },
                  size:{ less_than: Settings.micropost.number.megabytes, message: I18n.t(".less_than_5MB") }

  scope :by_created_at, -> { order(created_at: :desc) }
  scope :recent_posts, -> { order created_at: :desc }
  scope :feed_user, -> user_id {where "user_id IN (?)", user_id}

  def display_image
    image.variant resize_to_limit: [Settings.micropost.resize_width, Settings.micropost.resize_height]
  end
end
