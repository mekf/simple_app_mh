# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content, :created_at # created_at for testing only
  belongs_to :user #10.10

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user) #11.43
    # followed_user_ids = user.followed_user_ids
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    
    #11.44
    # where("user_id IN (:followed_user_ids) OR user_id = :user_id",
    #       followed_user_ids: followed_user_ids, user_id: user)

    #11.45
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end
