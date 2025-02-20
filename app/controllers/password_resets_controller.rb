class PasswordResetsController < ApplicationController
  # Permite acesso a este controlador sem exigir autenticação
  skip_before_action :authenticate_user!

  # Define o usuário com base no email salvo na sessão, antes das ações :edit e :update
  before_action :set_user, only: [:edit, :update]

  # Exibe o formulário para solicitar redefinição de senha
  def new
  end

  # Processa a solicitação de redefinição de senha
  def create
    @user = User.find_by(email: params[:email])

    if @user
      session[:reset_password_email] = @user.email
      redirect_to edit_password_reset_path, notice: "Por favor, defina sua nova senha."
    else
      flash.now[:alert] = "Email não encontrado."
      render :new, status: :unprocessable_entity
    end
  end

  # Exibe o formulário para definir uma nova senha
  def edit
    unless @user
      redirect_to new_password_reset_path, alert: "Por favor, informe seu email novamente."
    end
  end

  # Atualiza a senha do usuário
  def update
    if @user&.update(password_params)
      session.delete(:reset_password_email)
      redirect_to new_user_session_path, notice: "Senha atualizada com sucesso! Por favor, faça login."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Busca o usuário pelo email salvo na sessão
  def set_user
    @user = User.find_by(email: session[:reset_password_email])
  end

  # Permite apenas os parâmetros necessários para a redefinição de senha
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
