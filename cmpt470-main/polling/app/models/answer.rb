class Answer < ActiveRecord::Base
	belongs_to :poll
	validates_presence_of :ans
            has_many :votes, -> {distinct}, inverse_of: :answer, dependent: :destroy
            
	def to_s
		ans
	end
end
