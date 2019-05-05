class CreateChalanges < ActiveRecord::Migration[5.2]
  def change
    create_table :chalanges do |t|
      t.string :Name
      t.integer :geal
      t.integer :kind

      t.timestamps
    end
  end
end
