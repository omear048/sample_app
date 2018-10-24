class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') } #The order here is ’created_at DESC’, where DESC is SQL for “descend- ing”, i.e., in descending order from newest to oldest.(Pg. 522) 
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true  
end
