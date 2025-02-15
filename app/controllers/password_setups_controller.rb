class PasswordSetupsController < ApplicationController
  # Garante que o usuário esteja autenticado antes de acessar qualquer ação
  before_action :authenticate_user!

  # Impede o acesso se a alteração de senha não for obrigatória
  before_action :ensure_password_change_required

  # Exibe o formulário para configuração da senha
  def edit
  end

  # Processa a atualização da senha do usuário
  def update
    if current_user.update_with_password(password_params)
      # Marca que a troca de senha não é mais obrigatória
      current_user.update!(force_password_change: false)

      # Mantém o usuário logado após a mudança de senha
      bypass_sign_in(current_user)

      redirect_to authenticated_root_path, notice: "Senha definida com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Permite apenas os parâmetros necessários para alteração de senha
  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  # Verifica se o usuário realmente precisa trocar a senha
  def ensure_password_change_required
    unless current_user.force_password_change?
      redirect_to authenticated_root_path
    end
  end
end
