class Response < ApplicationRecord
  belongs_to :form
  belongs_to :user

  validates :answers, presence: true
  validates :form, presence: true
  validates :user, presence: true
  validate :user_enrolled_in_class
  validate :form_is_active, on: :create
  validate :required_answers_present

  def answers_array
    return {} if answers.nil?
    answers.is_a?(String) ? JSON.parse(answers) : answers
  end

  private

  def user_enrolled_in_class
    unless user.all_classes.include?(form.school_class)
      errors.add(:base, "Usuário deve estar vinculado à turma")
    end
  end

  def form_is_active
    unless form.active?
      errors.add(:base, "Formulário deve estar ativo para receber respostas")
    end
  end

  def required_answers_present
    return unless answers.present? && form&.form_template&.questions.present?

    questions = form.form_template.questions_array
    answers_data = answers_array

    questions.each_with_index do |question, index|
      if question["required"] && (answers_data[index.to_s].blank? || answers_data[index.to_s].to_s.strip.empty?)
        errors.add(:base, "A questão '#{question["text"]}' é obrigatória")
      end
    end
  end
end
