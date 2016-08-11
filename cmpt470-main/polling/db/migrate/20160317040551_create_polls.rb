class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :quest

      t.timestamps null: false
    end
  end
end
