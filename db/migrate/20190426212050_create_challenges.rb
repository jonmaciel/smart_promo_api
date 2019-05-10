class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.string :name
      t.integer :goal
      t.integer :kind

      t.timestamps
    end
  end
end
