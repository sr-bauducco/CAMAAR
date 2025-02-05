class PasswordResetsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: [ :edit, :update ]

  def new
  end

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

  def edit
    unless @user
      redirect_to new_password_reset_path, alert: "Por favor, informe seu email novamente."
    end
  end

  def update
    if @user&.update(password_params)
      session.delete(:reset_password_email)
      redirect_to new_user_session_path, notice: "Senha atualizada com sucesso! Por favor, faça login."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(email: session[:reset_password_email])
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
