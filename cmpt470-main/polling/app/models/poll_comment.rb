class PollComment < ActiveRecord::Base
  belongs_to :poll
  validates_presence_of :commenter_id, :body
	
	before_validation(:on => :create) do
		#self.commenter_id = current_user.id
	end
  
	def to_s
		body
	end
end
