class CreateFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :funds do |t|
      t.float :value
      t.integer :status
      t.references :sender_wallet, index: true, foreign_key: { to_table: :wallets }
      t.references :recipient_owner, index: true, foreign_key: { to_table: :wallets }

      t.timestamps
    end
  end
end
