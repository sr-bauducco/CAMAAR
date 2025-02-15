class PendingFormsController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar qualquer ação
  before_action :authenticate_user!

  # Lista os formulários pendentes para o usuário atual
  def index
    @forms = Form.active
                 .joins(:school_class) # Faz um JOIN com a tabela de turmas
                 .includes(:form_template, school_class: :subject) # Carrega os templates de formulário e as disciplinas associadas
                 .where(target_audience: current_user_audience) # Filtra pelo público-alvo do usuário (professores ou alunos)
                 .where(school_classes: { id: user_classes }) # Restringe os formulários às turmas do usuário
                 .where.not(id: current_user.responses.select(:form_id)) # Exclui os formulários já respondidos
  end

  private

  # Retorna o público-alvo do usuário atual (professores ou alunos)
  def current_user_audience
    current_user.teacher? ? :teachers : :students
  end

  # Retorna os IDs das turmas às quais o usuário está associado
  def user_classes
    current_user.all_classes.pluck(:id)
  end
end
