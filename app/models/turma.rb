class Turma < ApplicationRecord
  has_many :formularios
  validates :nome, presence: true
end
