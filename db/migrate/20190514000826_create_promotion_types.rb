class CreatePromotionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :promotion_types do |t|
      t.string :label, null: false

      t.timestamps
    end
  end
end
