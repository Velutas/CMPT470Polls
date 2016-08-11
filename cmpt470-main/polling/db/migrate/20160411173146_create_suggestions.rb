class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.integer :from_id
      t.integer :to_id
      t.boolean :accepted, default: false

      t.timestamps null: false
    end
  end
end
