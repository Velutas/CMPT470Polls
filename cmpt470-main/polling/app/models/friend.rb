class Friend < ActiveRecord::Base
    validates :from_id, uniqueness: true
    validates :to_id, uniqueness: true
    belongs_to :user
end
