class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t| # id: false evita a criação da coluna padrão 'id'
      t.string :user_id, primary_key: true # Define 'user_id' como chave primária
      t.string :enrollment, null: false, unique: true
      t.string :email, null: false, unique: true
      t.string :name, null: false
      t.string :role, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
