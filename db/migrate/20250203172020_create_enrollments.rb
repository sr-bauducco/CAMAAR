class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
