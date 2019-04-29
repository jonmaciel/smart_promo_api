class CreateChalangeProgresses < ActiveRecord::Migration[5.2]
  def change
    create_table :chalange_progresses do |t|
      t.integer :progress
      t.belongs_to :chalange, foreign_key: true
      t.belongs_to :customer, foreign_key: true

      t.timestamps
    end
  end
end
