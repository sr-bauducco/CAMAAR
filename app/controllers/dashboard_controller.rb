class DashboardController < ApplicationController
  # Garante que o usuário esteja autenticado antes de qualquer ação
  before_action :authenticate_user!

  # Método responsável por carregar os formulários pendentes de acordo com o tipo de usuário
  # Argumento: Nenhum
  # Retorno: Atribui à variável de instância @pending_forms os formulários pendentes
  # Efeito colateral: Redireciona ou apresenta os formulários pendentes dependendo do tipo de usuário
  def index
    @pending_forms = current_user.student? ? pending_student_forms : pending_admin_forms
  end

  private

  # Método responsável por buscar os formulários pendentes para um estudante
  # Argumento: Nenhum
  # Retorno: Uma consulta ao banco de dados para buscar formulários ativos para o estudante,
  #         que não tenham sido respondidos por ele
  # Efeito colateral: Nenhum
  def pending_student_forms
    Form.joins(school_class: :enrollments)
        .where(enrollments: { user: current_user })  # Verifica os formulários associados ao usuário
        .where(status: :active)  # Filtra os formulários com status ativo
        .where.not(id: current_user.responses.select(:form_id))  # Exclui formulários que o usuário já respondeu
  end

  # Método responsável por buscar os formulários pendentes para um administrador
  # Argumento: Nenhum
  # Retorno: Uma consulta ao banco de dados para buscar formulários associados ao departamento do administrador
  # Efeito colateral: Nenhum
  def pending_admin_forms
    if current_user.admin?
      # Se o usuário for um administrador, busca formulários associados ao seu departamento
      Form.joins(school_class: { subject: :department })
          .where(departments: { id: current_user.department_id })  # Filtra os formulários do departamento do admin
    else
      # Para outros tipos de usuário, retorna uma consulta vazia
      Form.none
    end
  end
end
