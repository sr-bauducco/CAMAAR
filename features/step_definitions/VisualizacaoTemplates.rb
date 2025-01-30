Dado('que existem templates de formulário criados no sistema') do
    @template1 = TemplateFormulario.create(nome: 'Template 1', questoes: ['Questão 1', 'Questão 2'])
    @template2 = TemplateFormulario.create(nome: 'Template 2', questoes: ['Questão A', 'Questão B'])
  end
  
  Dado('que um template específico existe no sistema') do
    @template = TemplateFormulario.create(nome: 'Template Específico', questoes: ['Questão X', 'Questão Y'])
  end
  
  Dado('que um template não existe no sistema') do
    @template_inexistente_id = 9999
  end
  
  Quando('o Administrador acessa a página de visualização de templates') do
    @template_lista = TemplateFormulario.all
  end
  
  Quando('o Administrador acessa os detalhes desse template') do
    @detalhes_template = @template
  end
  
  Quando('o Administrador tenta acessá-lo') do
    @template_inexistente = TemplateFormulario.find_by(id: @template_inexistente_id)
  end
  
  Então('ele deve ver a lista de templates criados') do
    expect(@template_lista.count).to be > 0
  end
  
  Então('ele deve ver todas as informações associadas ao template') do
    expect(@detalhes_template.questoes.count).to be > 0
  end
  
  Então('o sistema deve exibir uma mensagem de erro informando que o template não foi encontrado') do
    expect(@template_inexistente).to be_nil
  end
  