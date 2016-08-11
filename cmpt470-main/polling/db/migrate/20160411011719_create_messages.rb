class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_id
      t.integer :to_id
      t.string :content
      t.string :title

      t.timestamps null: false
    end
  end
end
