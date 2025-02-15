class ResponsesController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar qualquer ação
  before_action :authenticate_user!
  # Define o formulário antes das ações `new` e `create`
  before_action :set_form, only: [:new, :create]
  # Verifica se o usuário pode responder ao formulário antes das ações `new` e `create`
  before_action :ensure_can_respond, only: [:new, :create]

  # Exibe o formulário para resposta
  def new
    @response = Response.new(form: @form)
    @questions = @form.form_template.questions_array
  end

  # Processa o envio das respostas do usuário
  def create
    @response = Response.new(form: @form, user: current_user)
    answers = {}

    # Processa as respostas enviadas pelo formulário
    if params[:response][:answers].present?
      params[:response][:answers].each_with_index do |answer, index|
        answers[index.to_s] = answer unless answer.blank?
      end
    end

    @response.answers = answers

    if @response.save
      redirect_to pending_forms_path,
                  notice: "Suas respostas foram enviadas com sucesso para #{@form.school_class.subject.name} - #{@form.school_class.semester}."
    else
      @questions = @form.form_template.questions_array
      flash.now[:alert] = "Por favor, corrija os erros indicados abaixo."
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Busca o formulário com base no parâmetro `form_id`
  def set_form
    @form = Form.find(params[:form_id])
  end

  # Permite apenas a estrutura correta de parâmetros para respostas
  def response_params
    params.require(:response).permit(answers: [])
  end

  # Garante que o usuário pode responder ao formulário
  def ensure_can_respond
    unless @form.active?
      redirect_to pending_forms_path, alert: "Este formulário não está mais disponível para respostas."
      return
    end

    if current_user.responses.exists?(form: @form)
      redirect_to pending_forms_path, alert: "Você já respondeu este formulário."
      return
    end

    # Verifica se o formulário é destinado ao público correto (professores ou alunos)
    audience = current_user.teacher? ? :teachers : :students
    unless @form.target_audience.to_sym == audience
      redirect_to pending_forms_path, alert: "Este formulário não é destinado ao seu perfil."
      return
    end

    # Verifica se o usuário pertence à turma associada ao formulário
    unless current_user.all_classes.include?(@form.school_class)
      redirect_to pending_forms_path, alert: "Você não está vinculado a esta turma."
    end
  end
end
