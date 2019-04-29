class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.integer :source_id 
      t.string :source_type
      t.string :code

      t.timestamps
    end

    add_index :wallets, [:source_id, :source_type]
  end
end
