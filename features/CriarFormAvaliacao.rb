Dado('que o Administrador deseja criar um formulário de avaliação baseado em um template existente') do
    @formulario_avaliacao = FormularioAvaliacao.new
  end
  
  Dado('que ele escolhe um template de formulário válido') do
    @template_formulario = TemplateFormulario.create(nome: 'Template Avaliação', questoes: ['Questão 1', 'Questão 2'])
    @formulario_avaliacao.template = @template_formulario
  end
  
  Dado('que ele seleciona uma ou mais turmas para associar ao formulário') do
    @turma1 = Turma.create(nome: 'Turma A')
    @turma2 = Turma.create(nome: 'Turma B')
    @formulario_avaliacao.turmas = [@turma1, @turma2]
  end
  
  Dado('que ele não seleciona um template de formulário') do
    @formulario_avaliacao.template = nil
  end
  
  Dado('que ele não seleciona nenhuma turma') do
    @formulario_avaliacao.turmas = []
  end
  
  Quando('ele salva o formulário de avaliação') do
    begin
      @formulario_avaliacao.salvar
      @criacao_sucesso = true
    rescue => e
      @criacao_sucesso = false
      @erro = e.message
    end
  end
  
  Quando('ele tenta salvar o formulário de avaliação') do
    begin
      @formulario_avaliacao.salvar
      @criacao_sucesso = true
    rescue => e
      @criacao_sucesso = false
      @erro = e.message
    end
  end
  
  Então('o formulário deve ser criado com sucesso') do
    expect(@criacao_sucesso).to be true
  end
  
  Então('deve estar associado ao template e às turmas escolhidas') do
    expect(@formulario_avaliacao.template).not_to be_nil
    expect(@formulario_avaliacao.turmas).not_to be_empty
  end
  
  Então('a criação do formulário deve falhar') do
    expect(@criacao_sucesso).to be false
  end
  
  Então('uma mensagem de erro deve ser exibida informando que o template é obrigatório') do
    expect(@erro).to include('Template é obrigatório')
  end
  
  Então('uma mensagem de erro deve ser exibida informando que pelo menos uma turma deve ser selecionada') do
    expect(@erro).to include('Pelo menos uma turma deve ser selecionada')
  end
  