Dado('que um usuário recebeu um e-mail de solicitação de cadastro com um link para definir a senha') do
    @usuario = Usuario.create(email: 'usuario@example.com')
    @token = TokenDefinicaoSenha.gerar_para(@usuario)
  end
  
  Dado('que um usuário tenta acessar um link inválido para definição de senha') do
    @token_invalido = 'token_invalido'
  end
  
  Dado('que um usuário recebeu um e-mail de solicitação de cadastro com um link válido') do
    @usuario = Usuario.create(email: 'usuario@example.com')
    @token = TokenDefinicaoSenha.gerar_para(@usuario)
  end
  
  Dado('que ele já utilizou a senha fornecida anteriormente') do
    @senha_antiga = 'senha123'
    @usuario.definir_senha(@token, @senha_antiga)
  end
  
  Quando('ele acessa o link e fornece uma nova senha') do
    @nova_senha = 'novaSenha456'
    @usuario.definir_senha(@token, @nova_senha)
  end
  
  Quando('ele tenta acessar um link inválido para definição de senha') do
    @resultado = Usuario.definir_senha(@token_invalido, 'novaSenha456')
  end
  
  Quando('ele tenta definir a mesma senha') do
    @resultado = @usuario.definir_senha(@token, @senha_antiga)
  end
  
  Então('a senha deve ser definida com sucesso') do
    expect(@usuario.senha).to eq(@nova_senha)
  end
  
  Então('o usuário deve conseguir acessar o sistema com a nova senha') do
    expect(Usuario.authenticate(email: @usuario.email, senha: @nova_senha)).to be true
  end
  
  Então('o sistema deve exibir uma mensagem de erro informando que o link é inválido ou expirado') do
    expect(@resultado).to eq('Link inválido ou expirado')
  end
  
  Então('o sistema deve exibir uma mensagem de erro informando que a senha não pode ser reutilizada') do
    expect(@resultado).to eq('A senha não pode ser reutilizada')
  end
  