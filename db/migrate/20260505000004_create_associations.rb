class CreateAssociations < ActiveRecord::Migration[8.1]
  def change
    create_table :associations do |t|
      t.string :name
      t.integer :word_id, null: false
      t.integer :association_id, null: false
      t.integer :user_id
      t.integer :count, default: 1
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.boolean :fill_in, default: false
      t.boolean :scrubbed, default: false
      t.boolean :user_word, default: false
      t.timestamps
    end

    add_index :associations, [ :word_id, :association_id ], unique: true
    add_index :associations, :word_id
    add_index :associations, :association_id
  end
end
