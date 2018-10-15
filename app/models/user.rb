class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token        #This code, called a method reference, arranges for Rails to look for a method called create_remember_token and run it before saving the user

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password #Many different tests are dependent on this one

  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)   #We've hashed the remember token using SHA1, a hashing algorithm for security purposes
  end

  private

    def create_remember_token  #Method only needs to be used internally by the user model so it's made private 
      self.remember_token = User.digest(User.new_remember_token) #Using self ensures that assignment sets the user's remember_token, and as a result it will be written to the database along with the other attributes when the user is saved 
    end

end
