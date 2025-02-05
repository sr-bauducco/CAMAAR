class ResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_form, only: [ :new, :create ]
  before_action :ensure_can_respond, only: [ :new, :create ]

  def new
    @response = Response.new(form: @form)
    @questions = @form.form_template.questions_array
  end

  def create
    @response = Response.new(form: @form, user: current_user)
    answers = {}

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

  def set_form
    @form = Form.find(params[:form_id])
  end

  def response_params
    params.require(:response).permit(answers: [])
  end

  def ensure_can_respond
    unless @form.active?
      redirect_to pending_forms_path, alert: "Este formulário não está mais disponível para respostas."
      return
    end

    if current_user.responses.exists?(form: @form)
      redirect_to pending_forms_path, alert: "Você já respondeu este formulário."
      return
    end

    audience = current_user.teacher? ? :teachers : :students
    unless @form.target_audience.to_sym == audience
      redirect_to pending_forms_path, alert: "Este formulário não é destinado ao seu perfil."
      return
    end

    unless current_user.all_classes.include?(@form.school_class)
      redirect_to pending_forms_path, alert: "Você não está vinculado a esta turma."
    end
  end
end
