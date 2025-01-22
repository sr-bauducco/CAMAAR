Dado('que eu estou na página de login') do
  # Código para navegar até a página de login
  visit '/login'
end

Quando('eu solicito a redefinição de senha') do
  # Código para preencher o formulário de redefinição de senha
  fill_in 'email', with: 'usuario@exemplo.com'
  click_button 'Solicitar redefinição de senha'
end

Então('eu devo receber um e-mail com o link para redefinir minha senha') do
  # Código para verificar que um e-mail foi enviado com o link
  expect(ActionMailer::Base.deliveries.last.to).to include('usuario@exemplo.com')
  expect(ActionMailer::Base.deliveries.last.subject).to include('Redefinir sua senha')
end

Dado('que eu recebi um e-mail com o link de redefinição de senha') do
  # Código para verificar que o e-mail foi recebido
  @link_redefinicao = 'http://meusistema.com/redefinir_senha?token=12345'
end

Quando('eu clico no link de redefinição') do
  visit @link_redefinicao
end

Quando('eu insiro uma nova senha válida') do
  # Preenchendo a nova senha e confirmação
  fill_in 'nova_senha', with: 'NovaSenha123!'
  fill_in 'confirmar_senha', with: 'NovaSenha123!'
  click_button 'Redefinir senha'
end

Então('minha senha deve ser atualizada com sucesso') do
  expect(page).to have_content('Senha alterada com sucesso')
end

Então('eu devo ser redirecionado para a página de login') do
  expect(current_path).to eq('/login')
end

# CENÁRIO TRISTE

Quando('eu solicito a redefinição de senha com um e-mail inválido') do
  # Inserindo um e-mail inválido
  fill_in 'email', with: 'emailinvalido@dominio.com'
  click_button 'Solicitar redefinição de senha'
end

Então('eu não devo receber um e-mail com o link para redefinir minha senha') do
  # Verifica se nenhum e-mail foi enviado
  expect(ActionMailer::Base.deliveries).to be_empty
end

Então('eu devo ver uma mensagem de erro informando que o e-mail não foi enviado') do
  # Verifica se a mensagem de erro foi exibida na página
  expect(page).to have_content('Erro ao enviar e-mail de redefinição. Verifique o e-mail informado.')
end
