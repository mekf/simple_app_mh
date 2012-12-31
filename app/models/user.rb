# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :name, :password, :password_confirmation
  has_many :microposts, dependent: :destroy #10.11, #10.16: destroy a user -> no more micro post
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy #11.4
  has_many :followed_users, through: :relationships, source: :followed #11.14, overwire followed as followed_users
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy #11.16
  has_many :followers, through: :reverse_relationships, source: :follower

  #both work
  #before_save { |user| user.email = email.downcase }
  before_save { self.email.downcase! }
  before_save :generate_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private
    def generate_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
