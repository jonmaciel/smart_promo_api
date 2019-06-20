class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :description
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean :highlighted
      t.integer :cost
      t.integer :goal_quantity
      t.float :index
      t.boolean :active

      t.belongs_to :partner, foreign_key: true
      t.references :promotion_type, index: true, null: false

      t.timestamps
    end
  end
end
