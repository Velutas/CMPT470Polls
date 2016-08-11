class PollsController < ApplicationController
	before_action :set_poll, only: [:show, :edit, :update, :destroy]
	def index
		@polls = Poll.search(params[:searchByKeyword], params[:searchByTag], params[:sortOption]).paginate(:page => params[:page])
		@tagList = Tag.select(:name).where("name != ''").order(:name).distinct
		
		@NumLoops = 4
		if logged_in?
			@user = current_user
		end
		
		# Poll count from http://stackoverflow.com/questions/25178822/most-frequent-value-in-active-record-coloumn
		@votes = Vote.group(:poll_id).order('count_poll_id DESC').limit(5).count(:poll_id)
		@votes = @votes.keys
		@popular_polls = @polls.where(id: @votes)
	end
	
	def popular
		# Poll count from http://stackoverflow.com/questions/25178822/most-frequent-value-in-active-record-coloumn
		# @votes = Vote.pluck(:poll_id)
		@votes = Vote.group(:poll_id).order('count_poll_id DESC').limit(5).count(:poll_id)
		@votes = @votes.keys
		@polls = Poll.where(id: @votes)
		if logged_in?
			@user = current_user
		end
	end
	
	def show
		@user = current_user
		@poll = Poll.find(params[:id])
		
		{'poll_comment' => {:commenter_id => current_user}}
		
		if @poll.creator_id
			@creator = User.find(@poll.creator_id)
		else 
			@creator = nil
		end
		if logged_in?
			@vote = Vote.where(poll_id: @poll.id, user_id: current_user.id)
			if(@vote.count == 0)
				@vote = Vote.new
			else
				@vote = @vote[0]
			end
		else
			@vote = Vote.where(poll_id: @poll.id, user_id: nil)
		end
	end

	def edit
	  @poll.answers.build
	end
	
	def new
		@poll = Poll.new
		@numloops = 5
		#@answers = @poll.answers.build
		#2.times{  }
		@poll.answers.build
		@poll.answers.build
		@user = current_user
	end

	def create
		@poll = Poll.new(poll_params)
		@numloops = 5
		@user = current_user
		@poll[:creator_id] = current_user.id
		respond_to do |format|
			if @poll.save
				flash[:info] = 'Poll was successfully created.' 
				#redirect_to poll_path(@poll)
				format.html { redirect_to @poll }
				format.json { render :show, status: :created, location: @poll }
			else
				format.html { render :new }
				format.json { render json: @poll.errors, status: :unprocessable_entity }
			end
		end
	end
	
	
	def update
		respond_to do |format|
			if @poll.update(poll_params)
				flash[:info] = 'Poll was successfully updated.'
				redirect_to @poll
				# format.html { redirect_to @poll }
				mat.json { render :show, status: :ok, location: @poll }
			else
				format.html { render :edit }
				format.json { render json: @poll.errors, status: :unprocessable_entity }
			end
		end
	  end
	  
	# The following should be restricted to Admin privileges 
	def destroy
		@poll = Poll.find(params[:id])
		@poll.destroy
		
		redirect_to polls_path
	end
	
	def addvote
	
	end
	
	def num_ans
	
	end
	
	private
		def poll_params
			params.require(:poll).permit(:quest, :desc, creator_id: current_user.id, answers_attributes: [:id, :ans, :_destroy], tags_attributes: [:id, :name, :_destroy])
		end
		def set_poll
			@poll = Poll.find(params[:id])
		end
end
