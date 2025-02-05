Given('Está logado como dicente ou docente') do
  @usuario = Usuario.new('Dicente', 'usuario@exemplo.com', 'senha_segura')
  puts "Usuário logado: #{@usuario.nome}"
end

When('O usuário preenche os campos e-mail, senha e um tipo denominado dicente ou docente') do
  expect(@usuario).not_to be_nil
  puts "Campos preenchidos com: E-mail - #{@usuario.email}, Tipo - #{@usuario.tipo}"
end

And('Depois do preenchimento, o usuário clica no botão Logar') do
  @login_sucesso = @usuario.autenticar
end

Then('Após logar, o sistema exibirá "Logado com sucesso"') do
  if @login_sucesso
    puts "Logado com sucesso"
  else
    raise "Falha ao logar"
  end
end

Given('Falha no login do usuário') do
  @usuario_invalido = Usuario.new(nil, nil, nil) # Usuário com dados inválidos
end

When('O usuário não preenche corretamente o e-mail, senha ou tipo {string}') do |tipo|
  @login_falhou = !@usuario_invalido.autenticar
  puts "Tentativa de login com tipo inválido: #{tipo}"
end

And('Os dados não existem na base de dados') do
  expect(@login_falhou).to be true
end

Then('O sistema exibirá "E-mail e/ou senha incorretos"') do
  if @login_falhou
    puts "E-mail e/ou senha incorretos"
  else
    raise "Erro: Mensagem de falha não exibida"
  end
end
