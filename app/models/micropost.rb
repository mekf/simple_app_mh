class Micropost < ActiveRecord::Base
  attr_accessible :content, :created_at # created_at for testing only
  belongs_to :user #10.10

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'
end
