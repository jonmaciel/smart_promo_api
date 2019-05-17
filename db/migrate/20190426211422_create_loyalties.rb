class CreateLoyalties < ActiveRecord::Migration[5.2]
  def change
    create_table :loyalties do |t|
      t.integer :type
      t.boolean :active, default: true
      t.boolean :notification, default: true
      t.belongs_to :customer, index: true
      t.belongs_to :partner, index: true

      t.timestamps
    end

    add_index :loyalties, [:customer_id, :partner_id]
  end
end
