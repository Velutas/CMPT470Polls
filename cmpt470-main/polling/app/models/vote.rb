class Vote < ActiveRecord::Base
    belongs_to :answer, class_name: "Answer"
    validates :user_id, presence: true
    validates :poll_id, presence: true
    validates :answer_id, presence: true
    # uniqueness: { scope: [ :poll_id ] }
	
	def to_s
		user_id
	end
    validates :answer_id, presence: true, uniqueness: { scope: [ :poll_id, :user_id ] }
    def to_s
        answer_id
    end
end
