class User < ActiveRecord::Base
  attr_accessible :email, :name, :password_digest, :password, :password_confirmation, :authenticate
  has_many :microposts, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  validates :password_confirmation, presence: true
  after_validation { self.errors.messages.delete(:password_digest) }
  
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end
  
  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
end
