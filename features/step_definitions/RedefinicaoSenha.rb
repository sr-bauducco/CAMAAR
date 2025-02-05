Dado('que um usuário cadastrado deseja redefinir sua senha') do
    @usuario = Usuario.create(email: 'usuario@example.com', senha: 'senha123')
  end
  
  Dado('que ele solicita a redefinição informando seu e-mail') do
    @requisicao = RequisicaoSenha.nova(@usuario.email)
  end
  
  Dado('que um usuário recebeu um e-mail com um link válido para redefinição de senha') do
    @token = TokenRedefinicaoSenha.gerar_para(@usuario)
  end
  
  Dado('que um usuário tenta acessar um link inválido para redefinição de senha') do
    @token_invalido = 'token_invalido'
  end
  
  Dado('que um usuário não cadastrado tenta solicitar redefinição de senha') do
    @email_inexistente = 'naoexiste@example.com'
  end
  
  Quando('o sistema envia um e-mail com o link de redefinição') do
    @email_enviado = SistemaEmail.enviar_redefinicao(@usuario.email)
  end
  
  Quando('ele acessa o link e fornece uma nova senha') do
    @usuario.redefinir_senha(@token, 'novasenha123')
  end
  
  Quando('ele tenta acessar um link inválido para redefinição de senha') do
    @resultado = Usuario.redefinir_senha(@token_invalido, 'novasenha123')
  end
  
  Quando('ele informa um e-mail não existente no sistema') do
    @erro = RequisicaoSenha.nova(@email_inexistente).erro
  end
  
  Então('o usuário deve receber um e-mail contendo o link para redefinir sua senha') do
    expect(@email_enviado).to be true
  end
  
  Então('a senha deve ser atualizada com sucesso') do
    expect(@usuario.senha).to eq('novasenha123')
  end
  
  Então('o usuário deve conseguir acessar o sistema com a nova senha') do
    expect(Usuario.authenticate(email: @usuario.email, senha: 'novasenha123')).to be true
  end
  
  Então('o sistema deve exibir uma mensagem de erro informando que o link é inválido ou expirado') do
    expect(@resultado).to eq('Link inválido ou expirado')
  end
  
  Então('o sistema deve exibir uma mensagem de erro informando que o e-mail não está cadastrado') do
    expect(@erro).to eq('E-mail não encontrado')
  end
  