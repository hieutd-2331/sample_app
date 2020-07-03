class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  PERMIT_ATTRIBUTES = %i(name email password password_confirmation)
  attr_accessor :remember_token

  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.user.email.maximum_length}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.user.password.minimum_length}, allow_nil: true

  before_save :downcase_email
  has_secure_password

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

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private
  def downcase_email
    email.downcase!
  end
end
