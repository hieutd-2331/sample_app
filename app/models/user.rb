class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex

  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.user.email.max_length}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    self.mail.downcase!
  end
end
