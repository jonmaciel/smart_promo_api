class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.string :number
      t.integer :kind
      t.belongs_to :partner, foreign_key: true

      t.timestamps
    end
  end
end
