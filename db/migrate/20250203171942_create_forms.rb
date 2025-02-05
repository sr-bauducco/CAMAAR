class CreateForms < ActiveRecord::Migration[8.0]
  def change
    create_table :forms do |t|
      t.references :school_class, null: false, foreign_key: true
      t.references :form_template, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
