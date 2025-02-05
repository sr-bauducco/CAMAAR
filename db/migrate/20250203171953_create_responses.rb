class CreateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :responses do |t|
      t.references :form, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.json :answers

      t.timestamps
    end
  end
end
