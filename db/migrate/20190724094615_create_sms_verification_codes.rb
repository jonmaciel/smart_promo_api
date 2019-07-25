class CreateSmsVerificationCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :sms_verification_codes do |t|
      t.string :phone_number, index: true
      t.string :code
      t.boolean :validated, default: false

      t.timestamps
    end
  end
end
