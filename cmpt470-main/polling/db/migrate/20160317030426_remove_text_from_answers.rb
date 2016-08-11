class RemoveTextFromAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :text, :string
  end
end
