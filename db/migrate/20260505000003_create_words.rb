class CreateWords < ActiveRecord::Migration[8.1]
  def change
    create_table :words do |t|
      t.string :name, null: false
      t.integer :user_id
      t.datetime :last_grabbed
      t.integer :flagged, default: 0
      t.integer :r_rated, default: 0
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.boolean :got, default: false
      t.boolean :scrubbed, default: false
      t.boolean :user_word, default: false
      t.boolean :fill_in, default: false
      t.integer :tasks_count, default: 0
      t.integer :associations_count, default: 0
      t.timestamps
    end

    add_index :words, :name, unique: true
  end
end
