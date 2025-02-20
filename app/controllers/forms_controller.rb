class FormsController < ApplicationController
  # Garante que o usuário esteja autenticado antes de qualquer ação
  before_action :authenticate_user!

  # Define o formulário para as ações show, edit, update, destroy, results e export_results
  before_action :set_form, only: [:show, :edit, :update, :destroy, :results, :export_results]

  # Garante que apenas administradores possam acessar as ações deste controlador
  before_action :ensure_admin

  # Define os recursos do departamento para os formulários new, create, edit e update
  before_action :set_department_resources, only: [:new, :create, :edit, :update]

  # Lista todos os formulários do departamento do usuário
  def index
    @forms = Form.joins(school_class: { subject: :department })
                 .where(departments: { id: current_user.department_id })
  end

  # Exibe um formulário específico
  def show
  end

  # Inicializa um novo formulário
  def new
    @form = Form.new
  end

  # Exibe o formulário para edição
  def edit
  end

  # Cria um novo formulário de avaliação
  def create
    @form = Form.new(form_params)

    if @form.save
      redirect_to forms_path, notice: "Formulário de avaliação criado com sucesso. Os participantes selecionados poderão responder quando estiver ativo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Atualiza um formulário existente
  def update
    if @form.update(form_params)
      redirect_to forms_path, notice: "Formulário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Exclui um formulário, se ele não tiver respostas
  def destroy
    if @form.responses.any?
      redirect_to forms_path, alert: "Não é possível excluir um formulário que já possui respostas."
    else
      @form.destroy
      redirect_to forms_path, notice: "Formulário excluído com sucesso."
    end
  end

  # Exibe os resultados das respostas de um formulário
  def results
    @responses = @form.responses.includes(:user) # Carrega as respostas junto com os usuários para evitar N+1 queries
    @questions = @form.form_template.questions_array # Obtém as questões associadas ao template do formulário
    @total_possible_responses = calculate_total_possible_responses # Calcula o total de respostas possíveis
    @response_rate = calculate_response_rate # Calcula a taxa de resposta
  end

  # Exporta os resultados das respostas em formato CSV
  def export_results
    @responses = @form.responses.includes(:user)
    @questions = @form.form_template.questions_array

    respond_to do |format|
      format.csv {
        response.headers["Content-Type"] = "text/csv"
        response.headers["Content-Disposition"] = "attachment; filename=resultados_#{@form.form_template.name.parameterize}_#{Date.today}.csv"
      }
    end
  end

  private

  # Busca o formulário pelo ID e garante que pertence ao departamento do usuário
  def set_form
    @form = Form.joins(school_class: { subject: :department })
                .where(departments: { id: current_user.department_id })
                .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to forms_path, alert: "Formulário não encontrado ou você não tem permissão para acessá-lo."
  end

  # Define os templates de formulário e as turmas disponíveis no departamento do usuário
  def set_department_resources
    @templates = FormTemplate.where(department: current_user.department)
    @school_classes = SchoolClass.joins(subject: :department)
                                 .where(departments: { id: current_user.department_id })
                                 .order("subjects.name ASC, school_classes.semester DESC")

    # Redireciona se não houver templates de formulário disponíveis
    if @templates.empty?
      redirect_to new_form_template_path,
                  alert: "Você precisa criar um template de formulário antes de criar um novo formulário de avaliação."
      # Redireciona se não houver turmas cadastradas no departamento do usuário
    elsif @school_classes.empty?
      redirect_to root_path,
                  alert: "Não há turmas cadastradas em seu departamento. Entre em contato com o administrador do sistema."
    end
  end

  # Define os parâmetros permitidos para criação/atualização de formulários
  def form_params
    params.require(:form).permit(:form_template_id, :school_class_id, :status, :target_audience)
  end

  # Garante que apenas administradores possam acessar as ações do controlador
  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  # Calcula o total de respostas possíveis com base no público-alvo do formulário
  def calculate_total_possible_responses
    if @form.target_audience == "students"
      @form.school_class.students.count
    else
      @form.school_class.teachers.count
    end
  end

  # Calcula a taxa de resposta do formulário
  def calculate_response_rate
    return 0 if @total_possible_responses.zero?
    (@responses.count.to_f / @total_possible_responses * 100).round(1)
  end
end
