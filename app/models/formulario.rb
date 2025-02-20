class Formulario < ApplicationRecord
  # Associações
  belongs_to :turma

  # Validações
  validates :tipo, presence: true, inclusion: { in: ["Docentes", "Discentes"] }
  validates :turma_id, presence: true
  validates :titulo, presence: true
  validates :descricao, presence: true
end
