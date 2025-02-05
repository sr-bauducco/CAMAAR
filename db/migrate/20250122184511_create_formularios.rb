class CreateFormularios < ActiveRecord::Migration[8.0]
  def change
    create_table :formularios do |t|
      t.string :tipo
      t.references :turma, null: false, foreign_key: true
      t.string :titulo
      t.text :descricao

      t.timestamps
    end
  end
end
