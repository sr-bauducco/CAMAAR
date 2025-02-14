require 'rails_helper'

RSpec.describe Department, type: :model do
  describe "validações" do
    it "é válido com um nome único" do
      department = Department.new(name: "Ciência da Computação")
      expect(department).to be_valid
    end

    it "não é válido sem um nome" do
      department = Department.new(name: nil)
      expect(department).to_not be_valid
      expect(department.errors[:name]).to include("não pode ficar em branco")
    end

    it "não é válido com um nome duplicado" do
      Department.create!(name: "Matemática")
      department = Department.new(name: "Matemática")
      expect(department).to_not be_valid
      expect(department.errors[:name]).to include("já está em uso")
    end
  end

  describe "associações" do
    it { should have_many(:users) }
    it { should have_many(:subjects) }
  end

  describe "restrições de exclusão" do
    it "não pode ser deletado se tiver usuários" do
      department = Department.create!(name: "Engenharia")  # Nome válido
      user = User.create!(name: "Teste", email: "teste@example.com", password: "123456", department: department)

      expect { department.destroy }.to_not change(Department, :count)
      expect(department.errors[:base]).to include("Não é possível excluir o registro pois existem users dependentes")
    end

    it "não pode ser deletado se tiver matérias" do
      department = Department.create!(name: "Física")  # Nome válido
      subject = Subject.create!(name: "Mecânica Clássica", code: "MC101", department: department)  # Adicionando o código

      expect { department.destroy }.to_not change(Department, :count)
      expect(department.errors[:base]).to_not be_empty  # Verifica se há erro no campo base
    end
  end
end