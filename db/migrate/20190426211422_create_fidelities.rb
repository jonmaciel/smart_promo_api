class CreateFidelities < ActiveRecord::Migration[5.2]
  def change
    create_table :fidelities do |t|
      t.integer :type
      t.integer :notification
      t.boolean :active
      t.references :customer, index: true
      t.references :partner, index: true

      t.timestamps
    end
  end
end
