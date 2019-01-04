class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy     #Here the option dependent: :destroy in ... arranges for the dependent microposts (i.e., the ones belonging to the given user) to be destroyed when the user itself is destroyed. (Pg. 525) 
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", #pg. 597 - As you probably suspect, we will not be making a whole database table just to hold reverse relationships. Instead, we will exploit the underlying symmetry between followers and followed users to simulate a reverse_relationships table by passing followed_id as the primary key. In other words, where the relationships association uses the follower_id foreign key,
                                   class_name: "Relationship", #We actually have to include the class name for this relationship because otherwise Rails would look for a ReverseRelationship class, which doesn't exist 
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower 
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

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    #Micropost.where("user_id = ?", id)   #The question mark ensures that id is properly escaped before being included in the underlying SQL query, thereby avoiding a serious security hole called SQL injection. 
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user) 
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def create_remember_token  #Method only needs to be used internally by the user model so it's made private 
      self.remember_token = User.digest(User.new_remember_token) #Using self ensures that assignment sets the user's remember_token, and as a result it will be written to the database along with the other attributes when the user is saved 
    end

end
