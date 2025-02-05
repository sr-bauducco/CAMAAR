class AddTeacherToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_reference :enrollments, :teacher, null: true, foreign_key: { to_table: :users }
  end
end
