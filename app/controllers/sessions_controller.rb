class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:identifier]) || User.find_by(enrollment: params[:identifier])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email/Matrícula ou senha inválidos"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logout realizado com sucesso!"
  end
end