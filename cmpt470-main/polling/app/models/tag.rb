class Tag < ActiveRecord::Base
	belongs_to :poll
	validates :name, presence: true, length: {in: 3..25}
            
	def to_s
		name
	end
end
