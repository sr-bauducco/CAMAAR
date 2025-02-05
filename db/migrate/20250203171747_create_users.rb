class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :registration_number
      t.integer :role
      t.references :department, foreign_key: true

      t.timestamps
    end

    add_index :users, :registration_number, unique: true
  end
end
