class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation)

  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.user.email.maximum_length}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end

  class << self
    def digest string
      cost =  if ActiveModel::SecurePassword.min_cost
                BCrypt::Engine::MIN_COST
              else
                BCrypt::Engine.cost
              end
      BCrypt::Password.create string, cost: cost
    end
  end
end
