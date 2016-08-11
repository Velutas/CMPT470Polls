class Poll < ActiveRecord::Base
	has_many :answers, -> {distinct}, inverse_of: :poll, dependent: :destroy
	has_many :tags, -> {distinct}, inverse_of: :poll, dependent: :destroy
	has_many :poll_comments, inverse_of: :poll, dependent: :destroy
	accepts_nested_attributes_for :answers,
		allow_destroy: true,
		:reject_if => :all_blank
	accepts_nested_attributes_for :poll_comments,
		allow_destroy: true
	accepts_nested_attributes_for :tags,
		allow_destroy: true
	
	validates :quest, presence: true, length: { minimum: 1 }
	#validates :creator_id, presence: true
	# This is stopping postgres from loading the seed db
	#validates :answers, presence: true  
	#validates_presence_of :answers
	validates :tags, presence: true, length: { in: 0..10, message: ": maximum 10 entries allowed" }
	validates :answers, presence: true, length: { in: 2..10, message: ": 2-10 entries required" }
	
	validate :tag_unique_per_poll, :answer_unique_per_poll

	validates_associated :answers, :tags
	
	SORT_OPTIONS = ['Sort by...','Popularity','Newest','Oldest','A-Z Questions','A-Z Creators']
	self.per_page = 25

	def self.search(keyword, tag, sort)
		puts("Filtering by tag: ", tag)
		filteredPollKeys = self.all.pluck(:id)
		
		if !keyword.nil? && !keyword.empty?
			filteredPollKeys =  self.where('quest LIKE ? OR desc LIKE ?', "%#{keyword}%", "%#{keyword}%").pluck(:id)
		end
		
		if !tag.nil? && !tag.empty?
			filteredPollKeys =  self.joins(:tags).where(id: filteredPollKeys).where("name = ?", "#{tag}").pluck(:id)
		end
		
		if !sort.nil? && !sort.empty?
			case sort
			when "Newest"
				puts("Sorting by newest")
				return self.where(id: filteredPollKeys).order(created_at: :desc)
			when "Oldest"
				puts("Storting by oldest")
				return self.where(id: filteredPollKeys).order(created_at: :asc)
			when "Popularity"
				puts("Storting by popularity")
				votes = Vote.group(:poll_id, :id).order('count_poll_id DESC').count(:poll_id).pluck(:id)
				return self.where(id: filteredPollKeys).where(id: votes)
			when "A-Z Questions"
				puts("Storting by az_questions")
				return self.where(id: filteredPollKeys).order(quest: :desc)
			when "A-Z Creators"
				puts("Storting by az_creators")
				#http://guides.rubyonrails.org/active_record_querying.html
				return self.find_by_sql("SELECT users.name, users.id , polls.* FROM users INNER JOIN polls ON users.id = polls.creator_id ORDER BY users.name ASC").where(id: filteredPollKeys)
			end
		end
		
		return self.where(id: filteredPollKeys)
	end
	
	# Guided by: http://stackoverflow.com/questions/3371518/in-ruby-is-there-an-array-method-that-combines-select-and-map
	def tag_unique_per_poll
		for tag in self.tags
			if self.tags.map{|t| t if t.name == tag.name}.compact.length > 1
				errors.add tag.name, 'is a duplicate tag'
			end
		end
	end
	
	def answer_unique_per_poll
		for answer in self.answers
			if self.answers.map{|a| a if a.ans == answer.ans}.compact.length > 1
				errors.add answer.ans, 'is a duplicate answer'
			end
		end
	end
	
	def to_s
		quest
	end
	
	private
		def two_answers
			errors.add(:base, "You must enter at least two answers.") if answers.size < 2
		end
	
end
