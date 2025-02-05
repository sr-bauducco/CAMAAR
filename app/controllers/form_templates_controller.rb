class FormTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_form_template, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_admin

  def index
    @form_templates = FormTemplate.where(department: current_user.department)
  end

  def show
  end

  def new
    @form_template = FormTemplate.new(department: current_user.department)
  end

  def edit
  end

  def create
    @form_template = FormTemplate.new(form_template_params)
    @form_template.department = current_user.department

    if @form_template.save
      redirect_to form_templates_path, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @form_template.update(form_template_params)
      redirect_to form_templates_path, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @form_template.forms.any?
      redirect_to form_templates_path, alert: "Não é possível excluir um template que já está em uso."
    else
      @form_template.destroy
      redirect_to form_templates_path, notice: "Template excluído com sucesso."
    end
  end

  private

  def set_form_template
    @form_template = FormTemplate.where(department: current_user.department).find(params[:id])
  end

  def form_template_params
    # Processa os parâmetros das questões para incluir texto, tipo de resposta, opções e obrigatoriedade
    raw_params = params.require(:form_template).permit(:name, questions: {})

    if raw_params[:questions].present?
      # Converte os parâmetros das questões para o formato correto
      questions = raw_params[:questions].values.map do |question|
        {
          text: question[:text],
          answer_type: question[:answer_type],
          required: ActiveModel::Type::Boolean.new.cast(question[:required]),
          options: question[:options]
        }.compact
      end

      # Remove questões vazias e atualiza os parâmetros
      questions.reject! { |q| q[:text].blank? }
      raw_params[:questions] = questions.to_json
    end

    raw_params
  end

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
