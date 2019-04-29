class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :cellphone
      t.string :cpf
      t.string :email
      t.jsonb :interests

      t.timestamps
    end
  end
end
