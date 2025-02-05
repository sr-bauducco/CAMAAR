class CreateSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :school_classes do |t|
      t.references :subject, null: false, foreign_key: true
      t.string :semester

      t.timestamps
    end
  end
end
