class Message < ActiveRecord::Base
    belongs_to :user
    validates :from_id, presence: true
    validates :to_id, presence: true
    validates :title, presence: true
    validates :content, presence: true
end
