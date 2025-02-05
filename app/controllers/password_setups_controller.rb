class PasswordSetupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_password_change_required

  def edit
  end

  def update
    if current_user.update_with_password(password_params)
      current_user.update!(force_password_change: false)
      bypass_sign_in(current_user)
      redirect_to authenticated_root_path, notice: "Senha definida com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def ensure_password_change_required
    unless current_user.force_password_change?
      redirect_to authenticated_root_path
    end
  end
end
