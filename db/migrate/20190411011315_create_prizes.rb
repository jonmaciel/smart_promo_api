class CreatePrizes < ActiveRecord::Migration[5.2]
  def change
    create_table :prizes do |t|
      t.string :name
      t.float :value
      t.string :info
      t.references :promotion, foreign_key: true

      t.timestamps
    end
  end
end
