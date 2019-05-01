class CreatePartners < ActiveRecord::Migration[5.2]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :adress
      t.string :cnpj
      t.string :adress
      t.string :number
      t.string :complementary_address
      t.string :latitude
      t.string :longitude
      t.references :partner_profile, index: true

      t.timestamps
    end
  end
end
