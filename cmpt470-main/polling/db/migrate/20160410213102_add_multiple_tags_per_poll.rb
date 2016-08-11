class AddMultipleTagsPerPoll < ActiveRecord::Migration
  def change
	remove_column :polls, :tag, :string
  
	create_table :tags do |t|
		t.references :poll, index: true, foreign_key: true
		t.string :name
	end
  end
end
