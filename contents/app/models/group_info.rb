class GroupInfo < ApplicationRecord
  belongs_to :User, foreign_key: 'group_id', class_name: "User"
  belongs_to :User, foreign_key: 'user_id',  class_name: "User"
end
