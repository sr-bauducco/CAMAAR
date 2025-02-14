class AddNameToSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    add_column :school_classes, :name, :string
  end
end
