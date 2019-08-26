class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.integer :value_cents

      t.timestamps
    end
  end
end
