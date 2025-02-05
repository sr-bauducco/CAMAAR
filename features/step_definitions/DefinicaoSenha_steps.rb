@usuarios = [
  { email: 'usuario@exemplo.com', link_valido: true },
  { email: 'admin@exemplo.com', link_valido: false }
]

Given('O e-mail está cadastrado na base de dados') do
  @email = 'usuario@exemplo.com'
  @usuario = @usuarios.find { |u| u[:email] == @email }
  expect(@usuario).not_to be_nil
  puts "Usuário encontrado: #{@usuario[:email]}"
end

And('O link é válido e não expirou') do
  expect(@usuario[:link_valido]).to be true
  puts "Link válido para redefinição de senha."
end

And('O link é inválido ou já expirou') do
  @usuario[:link_valido] = false
  expect(@usuario[:link_valido]).to be false
  puts "Link inválido ou expirado."
end

When('O usuário clica no link de definição de senha') do
  if @usuario[:link_valido]
    @senha_pode_ser_definida = true
  else
    @senha_pode_ser_definida = false
  end
end

Then('O sistema permite que o usuário cadastre uma nova senha') do
  if @senha_pode_ser_definida
    puts "Campos para nova senha exibidos."
  else
    raise "Erro: Não foi possível cadastrar uma nova senha."
  end
end

And('A nova senha é armazenada na base de dados') do
  if @senha_pode_ser_definida
    @nova_senha = 'novaSenha123'
    puts "Nova senha cadastrada com sucesso: #{@nova_senha}"
  end
end

When('O usuário tenta clicar no link de definição de senha') do
  if !@usuario[:link_valido]
    @mensagem = 'Link inválido ou expirado'
  end
end

Then('O sistema exibe a mensagem "Link inválido ou expirado"') do
  if @mensagem == 'Link inválido ou expirado'
    puts @mensagem
  else
    raise "Erro: Mensagem esperada não exibida."
  end
end

And('O usuário é redirecionado para a página de solicitação de um novo link') do
  puts "Redirecionando para a página de solicitação de um novo link..."
end
