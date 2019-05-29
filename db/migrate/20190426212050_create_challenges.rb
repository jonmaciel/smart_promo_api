class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.string :name
      t.integer :goal
      t.belongs_to :promotion_type, index: true, null: false

      t.timestamps
    end
  end
end
