Given('O e-mail existe na base de dados') do
  @usuarios = ['usuario@exemplo.com'] # Base simulada
  @email = 'usuario@exemplo.com'
end

Given('O e-mail não existe na base de dados') do
  @usuarios = [] # Base simulada vazia
  @email = 'nao_existe@exemplo.com'
end

And('O campo de e-mail está preenchido') do
  expect(@email).not_to be_nil
  puts "Campo de e-mail preenchido com: #{@email}"
end

And('O campo de e-mail está vazio') do
  @email = nil
  puts "Campo de e-mail está vazio"
end

When('O sistema envia o link de redefinição de senha para o e-mail cadastrado') do
  if @usuarios.include?(@email)
    @mensagem = 'Link para redefinição enviado para o e-mail informado'
  else
    @mensagem = nil
  end
end

When('O sistema exibe a mensagem {string} ou {string}') do |mensagem1, mensagem2|
  if @email.nil?
    @mensagem = mensagem1
  elsif !@usuarios.include?(@email)
    @mensagem = mensagem2
  end
  puts @mensagem
end

Then('Exibe os campos para definir uma nova senha') do
  if @mensagem == 'Link para redefinição enviado para o e-mail informado'
    puts 'Exibindo campos para nova senha...'
  else
    raise 'Erro: Não foi possível redefinir a senha'
  end
end

And('Aparece a mensagem "Senha redefinida com sucesso"') do
  puts 'Senha redefinida com sucesso'
end

Then('Redireciona o usuário para a página de login') do
  puts 'Redirecionando para a página de login'
end
