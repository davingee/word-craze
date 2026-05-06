class CreateUserAssociations < ActiveRecord::Migration[8.1]
  def change
    create_table :user_associations do |t|
      t.integer :user_id
      t.integer :association_id, null: false
      t.integer :word_id, null: false
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.string :city
      t.string :region
      t.string :country
      t.string :postal_code
      t.timestamps
    end

    add_index :user_associations, :user_id
    add_index :user_associations, :word_id
  end
end
