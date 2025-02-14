# ApplicationController é a classe base para todos os controladores na aplicação.
# Ela gerencia autenticação e configuração de parâmetros do Devise, além de definir o fluxo pós-login.

class ApplicationController < ActionController::Base
  # Permite apenas navegadores modernos que suportam imagens webp, web push, badges, mapas de importação, CSS com aninhamento e CSS :has
  # Argumento: versions: :modern (especifica que apenas versões modernas de navegadores serão aceitas)
  # Efeito colateral: Impõe restrição de acesso a navegadores modernos que atendem aos requisitos.
  allow_browser versions: :modern

  # Garante que o usuário esteja autenticado antes de qualquer ação
  # Argumento: Nenhum
  # Efeito colateral: Redireciona o usuário para a página de login caso não esteja autenticado.
  before_action :authenticate_user!

  # Configura parâmetros permitidos para o Devise durante o registro e atualização de conta
  # Argumento: Nenhum
  # Efeito colateral: Modifica as permissões de parâmetros do Devise, permitindo campos adicionais.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Permite parâmetros personalizados durante o cadastro e atualização de conta com Devise
  # Argumento: Nenhum
  # Retorno: Nenhum (modifica diretamente os parâmetros permitidos no Devise)
  # Efeito colateral: Altera a configuração dos parâmetros permitidos para cadastro e atualização no Devise.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :registration_number, :role, :department_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # Define a rota de redirecionamento após o login do usuário
  # Argumento: resource (o usuário autenticado)
  # Retorno: Caminho (URL) para onde o usuário será redirecionado após o login
  # Efeito colateral: Redireciona o usuário para páginas específicas dependendo do seu estado (necessidade de mudar senha ou não).
  def after_sign_in_path_for(resource)
    if resource.force_password_change?
      # Redireciona o usuário para a página de configuração de senha, caso seja necessário mudar a senha
      edit_password_setup_path
    else
      # Redireciona para a página armazenada ou para a página inicial autenticada
      stored_location_for(resource) || authenticated_root_path
    end
  end
end
