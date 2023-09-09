class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  validates :message, presence: true, length: { maximum: 140 }
  # 空でなく140字以下
end
