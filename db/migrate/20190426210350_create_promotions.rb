class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :description
      t.integer :type
      t.datetime :start_datetime
      t.datetime :end_date_time
      t.boolean :highlighted
      t.float :index
      t.boolean :active
      t.belongs_to :partner, foreign_key: true

      t.timestamps
    end
  end
end
