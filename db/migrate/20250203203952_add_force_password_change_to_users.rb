class AddForcePasswordChangeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :force_password_change, :boolean, null: false, default: true
  end
end
