class FormsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_form, only: [ :show, :edit, :update, :destroy, :results, :export_results ]
  before_action :ensure_admin
  before_action :set_department_resources, only: [ :new, :create, :edit, :update ]

  def index
    @forms = Form.joins(school_class: { subject: :department })
                 .where(departments: { id: current_user.department_id })
  end

  def show
  end

  def new
    @form = Form.new
  end

  def edit
  end

  def create
    @form = Form.new(form_params)

    if @form.save
      redirect_to forms_path, notice: "Formulário de avaliação criado com sucesso. Os participantes selecionados poderão responder quando estiver ativo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @form.update(form_params)
      redirect_to forms_path, notice: "Formulário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @form.responses.any?
      redirect_to forms_path, alert: "Não é possível excluir um formulário que já possui respostas."
    else
      @form.destroy
      redirect_to forms_path, notice: "Formulário excluído com sucesso."
    end
  end

  def results
    @responses = @form.responses.includes(:user)
    @questions = @form.form_template.questions_array
    @total_possible_responses = calculate_total_possible_responses
    @response_rate = calculate_response_rate
  end

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

  def set_form
    @form = Form.joins(school_class: { subject: :department })
                .where(departments: { id: current_user.department_id })
                .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to forms_path, alert: "Formulário não encontrado ou você não tem permissão para acessá-lo."
  end

  def set_department_resources
    @templates = FormTemplate.where(department: current_user.department)
    @school_classes = SchoolClass.joins(subject: :department)
                               .where(departments: { id: current_user.department_id })
                               .order("subjects.name ASC, school_classes.semester DESC")

    if @templates.empty?
      redirect_to new_form_template_path,
        alert: "Você precisa criar um template de formulário antes de criar um novo formulário de avaliação."
    elsif @school_classes.empty?
      redirect_to root_path,
        alert: "Não há turmas cadastradas em seu departamento. Entre em contato com o administrador do sistema."
    end
  end

  def form_params
    params.require(:form).permit(:form_template_id, :school_class_id, :status, :target_audience)
  end

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def calculate_total_possible_responses
    if @form.target_audience == "students"
      @form.school_class.students.count
    else
      @form.school_class.teachers.count
    end
  end

  def calculate_response_rate
    return 0 if @total_possible_responses.zero?
    (@responses.count.to_f / @total_possible_responses * 100).round(1)
  end
end
