class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :idx
      t.string :status, null: false
      t.text :original_payload

      t.timestamps
    end
  end
end
