class AddTagToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :tag, :string
  end
end
