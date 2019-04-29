class CreatePartnerProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :partner_profiles do |t|
      t.string :name
      t.string :business

      t.timestamps
    end
  end
end
