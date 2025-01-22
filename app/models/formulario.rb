class Formulario < ApplicationRecord
  belongs_to :turma

  validates :tipo, presence: true, inclusion: { in: [ "Docentes", "Discentes" ] }
  validates :turma_id, presence: true
  validates :titulo, presence: true
  validates :descricao, presence: true
end
