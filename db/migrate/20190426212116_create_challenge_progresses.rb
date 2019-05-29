class CreateChallengeProgresses < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_progresses do |t|
      t.integer :progress, default: 0
      t.datetime :completed_datetime
      t.belongs_to :challenge, foreign_key: true
      t.belongs_to :customer, foreign_key: true

      t.timestamps
    end

    add_index :challenge_progresses, [:customer_id, :challenge_id]
  end
end
