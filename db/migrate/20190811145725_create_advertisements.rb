class CreateAdvertisements < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisements do |t|
      t.string :title
      t.string :description
      t.string :img_url
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean :active

      t.belongs_to :partner, foreign_key: true

      t.timestamps
    end

    add_index :advertisements, [:start_datetime]
    add_index :advertisements, [:end_datetime]
  end
end
