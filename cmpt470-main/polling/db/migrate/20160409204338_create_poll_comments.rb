class CreatePollComments < ActiveRecord::Migration
  def change
    create_table :poll_comments do |t|
      t.integer :commenter_id
      t.text :body
      t.references :poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
