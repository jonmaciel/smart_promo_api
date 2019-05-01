class CreateAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :auths do |t|
      t.boolean :adm, null: false, default: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.belongs_to :source, polymorphic: true, null: false

      t.timestamps
    end

    add_index :auths, [:source_id, :source_type]
  end
end
