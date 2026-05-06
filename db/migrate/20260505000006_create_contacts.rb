class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.string :email
      t.text :comments
      t.timestamps
    end
  end
end
