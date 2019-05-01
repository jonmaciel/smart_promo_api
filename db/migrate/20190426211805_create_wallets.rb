class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.belongs_to :source, polymorphic: true, null: false
      t.string :code

      t.timestamps
    end

    add_index :wallets, [:source_id, :source_type]
  end
end
