class FormTemplatesController < ApplicationController
  # Garante que o usuário esteja autenticado antes de qualquer ação
  before_action :authenticate_user!

  # Configura o FormTemplate para as ações de show, edit, update e destroy
  before_action :set_form_template, only: [:show, :edit, :update, :destroy]

  # Garante que apenas administradores possam acessar as ações do controlador
  before_action :ensure_admin

  # Exibe todos os templates de formulário do departamento do usuário
  # Argumento: Nenhum
  # Retorno: Atribui à variável de instância @form_templates todos os templates do departamento do usuário
  # Efeito colateral: Exibe a lista de templates para o usuário
  def index
    @form_templates = FormTemplate.where(department: current_user.department)
  end

  # Exibe um único template de formulário
  # Argumento: Nenhum
  # Retorno: Exibe o template específico encontrado
  # Efeito colateral: Nenhum
  def show
  end

  # Cria uma nova instância de FormTemplate associada ao departamento do usuário
  # Argumento: Nenhum
  # Retorno: Atribui à variável de instância @form_template uma nova instância de FormTemplate
  # Efeito colateral: Exibe o formulário para o usuário preencher
  def new
    @form_template = FormTemplate.new(department: current_user.department)
  end

  # Exibe o formulário para editar um template existente
  # Argumento: Nenhum
  # Retorno: Exibe o template existente para edição
  # Efeito colateral: Nenhum
  def edit
  end

  # Cria um novo template de formulário e o salva no banco de dados
  # Argumento: Nenhum
  # Retorno: Redireciona para a lista de templates com uma mensagem de sucesso, ou exibe o formulário de criação em caso de erro
  # Efeito colateral: Cria um novo registro de FormTemplate no banco de dados
  def create
    @form_template = FormTemplate.new(form_template_params)
    @form_template.department = current_user.department

    if @form_template.save
      redirect_to form_templates_path, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Atualiza um template de formulário existente no banco de dados
  # Argumento: Nenhum
  # Retorno: Redireciona para a lista de templates com uma mensagem de sucesso, ou exibe o formulário de edição em caso de erro
  # Efeito colateral: Atualiza o registro de FormTemplate no banco de dados
  def update
    if @form_template.update(form_template_params)
      redirect_to form_templates_path, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Exclui um template de formulário, se não estiver sendo utilizado
  # Argumento: Nenhum
  # Retorno: Redireciona para a lista de templates com uma mensagem de sucesso ou erro
  # Efeito colateral: Remove um registro de FormTemplate do banco de dados se ele não tiver formulários associados
  def destroy
    if @form_template.forms.any?
      redirect_to form_templates_path, alert: "Não é possível excluir um template que já está em uso."
    else
      @form_template.destroy
      redirect_to form_templates_path, notice: "Template excluído com sucesso."
    end
  end

  private

  # Define o template de formulário a ser usado nas ações show, edit, update e destroy
  # Argumento: Nenhum
  # Retorno: Atribui à variável de instância @form_template o template de formulário encontrado no banco de dados
  # Efeito colateral: Nenhum
  def set_form_template
    @form_template = FormTemplate.where(department: current_user.department).find(params[:id])
  end

  # Processa e valida os parâmetros para criação/atualização de um template de formulário
  # Argumento: Nenhum
  # Retorno: Retorna os parâmetros permitidos para o template, incluindo questões formatadas corretamente
  # Efeito colateral: Nenhum
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

  # Garante que apenas administradores possam acessar as ações de criar, editar, atualizar e excluir templates
  # Argumento: Nenhum
  # Retorno: Redireciona o usuário para a página inicial se não for administrador
  # Efeito colateral: Redireciona o usuário para a página inicial se não for administrador
  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
