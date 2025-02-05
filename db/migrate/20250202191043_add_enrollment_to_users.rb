class AddEnrollmentToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :enrollment, :string
    add_index :users, :enrollment, unique: true
  end
end
