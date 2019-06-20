class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :value, defalt: 1

      t.belongs_to :partner,        index: true, null: false

      t.belongs_to :wallet,               index: true, null: true
      t.belongs_to :contempled_promotion, index: true, null: true, foreign_key: { to_table: :promotions }

      t.timestamps
    end

    add_index :tickets, [:wallet_id, :partner_id]
  end
end
