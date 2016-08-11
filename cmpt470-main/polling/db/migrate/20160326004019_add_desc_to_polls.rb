class AddDescToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :desc, :string
  end
end
