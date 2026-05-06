class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :webauthn_id
      t.string :role, default: "user"
      t.string :city
      t.string :region
      t.string :country
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :webauthn_id, unique: true
  end
end
