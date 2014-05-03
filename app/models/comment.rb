class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  delegate :username, to: :user
  validates :comment, :presence => true 
end
