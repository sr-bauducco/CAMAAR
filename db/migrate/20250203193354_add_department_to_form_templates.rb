class AddDepartmentToFormTemplates < ActiveRecord::Migration[8.0]
  def change
    add_reference :form_templates, :department, null: false, foreign_key: true
  end
end
