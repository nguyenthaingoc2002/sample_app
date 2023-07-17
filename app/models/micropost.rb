class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order created_at: :desc}
  scope :relate_post, ->(user_ids){where user_id: user_ids}
  validates :content,
            presence: true,
            length: {maximum: Settings.digit.length_140}

  validates :image,
            content_type: {
              in: %w(image/jpeg image/gif image/png),
              message: I18n.t("errors.messages.invalid_image_format")
            },
            size: {
              less_than: 5.megabytes,
              message: I18n.t("errors.messages.invalid_image_size_html",
                              size: Settings.digit.size_5)
            }

  def display_image
    image.variant resize_to_limit: [Settings.digit.size_500,
                                    Settings.digit.size_500]
  end
end
