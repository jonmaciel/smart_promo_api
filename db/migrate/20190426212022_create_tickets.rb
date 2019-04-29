class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :type
      t.references :promotion
      t.references :wallet

      t.timestamps
    end
  end
end
