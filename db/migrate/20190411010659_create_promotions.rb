class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.string :name
      t.integer :value
      t.integer :type

      t.timestamps
    end
  end
end
