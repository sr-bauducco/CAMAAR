Dado('que existem formulários criados no sistema') do
    @formulario1 = FormularioAvaliacao.create(nome: 'Formulário 1')
    @formulario2 = FormularioAvaliacao.create(nome: 'Formulário 2')
  end
  
  Dado('que um formulário específico possui respostas registradas') do
    @formulario = FormularioAvaliacao.create(nome: 'Formulário de Teste')
    @resposta1 = Resposta.create(formulario: @formulario, conteudo: 'Resposta 1')
    @resposta2 = Resposta.create(formulario: @formulario, conteudo: 'Resposta 2')
  end
  
  Dado('que um formulário não existe no sistema') do
    @formulario_inexistente_id = 9999
  end
  
  Quando('o Administrador acessa a página de visualização de formulários') do
    @formulario_lista = FormularioAvaliacao.all
  end
  
  Quando('o Administrador acessa os detalhes desse formulário') do
    @respostas = @formulario.respostas
  end
  
  Quando('o Administrador tenta acessá-lo') do
    @formulario_inexistente = FormularioAvaliacao.find_by(id: @formulario_inexistente_id)
  end
  
  Então('ele deve ver a lista de formulários criados') do
    expect(@formulario_lista.count).to be > 0
  end
  
  Então('ele deve ver todas as respostas associadas ao formulário') do
    expect(@respostas.count).to be > 0
  end
  
  Então('o sistema deve exibir uma mensagem de erro informando que o formulário não foi encontrado') do
    expect(@formulario_inexistente).to be_nil
  end
  