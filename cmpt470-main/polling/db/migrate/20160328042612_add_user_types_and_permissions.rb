class AddUserTypesAndPermissions < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :integer, default: 0
    add_column :users, :contact_visibility, :integer, default: 0
    add_column :users, :response_visibility, :integer, default: 0
  end
end
