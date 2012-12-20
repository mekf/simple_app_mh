class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user #10.10

  validates :user_id, presence: true
end
