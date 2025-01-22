Dado('que um usuário cadastrado existe com um e-mail e senha válidos') do
    @usuario = Usuario.create(email: 'usuario@example.com', senha: 'senha123')
  end
  
  Dado('que um usuário cadastrado existe com uma matrícula e senha válidos') do
    @usuario = Usuario.create(matricula: '123456', senha: 'senha123')
  end
  
  Dado('que um usuário não cadastrado tenta acessar o sistema') do
    @usuario = Usuario.new(email: 'naoexiste@example.com', senha: 'senhaerrada')
  end
  
  Dado('que um usuário administrador cadastrado existe com um e-mail e senha válidos') do
    @admin = Usuario.create(email: 'admin@example.com', senha: 'admin123', admin: true)
  end
  
  Quando('ele tenta acessar o sistema com o e-mail e senha corretos') do
    @login_sucesso = Usuario.authenticate(email: @usuario.email, senha: @usuario.senha)
  end
  
  Quando('ele tenta acessar o sistema com a matrícula e senha corretos') do
    @login_sucesso = Usuario.authenticate(matricula: @usuario.matricula, senha: @usuario.senha)
  end
  
  Quando('ele insere um e-mail ou matrícula e senha incorretos') do
    @login_sucesso = Usuario.authenticate(email: @usuario.email, senha: @usuario.senha)
  end
  
  Então('o login deve ser realizado com sucesso') do
    expect(@login_sucesso).to be true
  end
  
  Então('ele deve ser redirecionado para a página inicial do sistema') do
    expect(@usuario.redirecionado_para).to eq('/dashboard')
  end
  
  Então('o login deve falhar') do
    expect(@login_sucesso).to be false
  end
  
  Então('uma mensagem de erro deve ser exibida informando credenciais inválidas') do
    expect(@usuario.erro).to eq('Credenciais inválidas')
  end
  
  Então('ele deve visualizar a opção de gerenciamento no menu lateral') do
    expect(@admin.visualiza_menu_gerenciamento?).to be true
  end