class FormulariosController < ApplicationController
  def index
    @formularios = Formulario.all
  end

  def new
    @formulario = Formulario.new
  end

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

  def formulario_params
    params.require(:formulario).permit(:tipo, :turma_id, :titulo, :descricao)
  end
end
