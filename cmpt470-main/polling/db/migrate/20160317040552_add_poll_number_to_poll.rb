class AddPollNumberToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :num, :integer
  end
end
