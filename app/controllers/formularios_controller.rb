class FormulariosController < ApplicationController
  # Lista todos os formulários
  def index
    @formularios = Formulario.all
  end

  # Inicializa um novo formulário
  def new
    @formulario = Formulario.new
  end

  # Cria um novo formulário com os parâmetros fornecidos
  def create
    @formulario = Formulario.new(formulario_params)

    if @formulario.save
      flash[:success] = "Formulário criado com sucesso"
      redirect_to formularios_path
    else
      flash.now[:error] = "Erro: Todos os campos obrigatórios devem ser preenchidos"
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Define os parâmetros permitidos para criação de um formulário
  def formulario_params
    params.require(:formulario).permit(:tipo, :turma_id, :titulo, :descricao)
  end
end
