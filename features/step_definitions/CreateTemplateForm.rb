Dado('que o Administrador deseja criar um novo template de formulário') do
    @template_formulario = TemplateFormulario.new
  end
  
  Dado('que ele fornece um nome e uma lista de questões válidas') do
    @template_formulario.nome = 'Avaliação de Desempenho'
    @template_formulario.questoes = ['Questão 1', 'Questão 2', 'Questão 3']
  end
  
  Dado('que ele não fornece um nome para o template') do
    @template_formulario.nome = nil
    @template_formulario.questoes = ['Questão 1', 'Questão 2']
  end
  
  Dado('que ele não fornece nenhuma questão') do
    @template_formulario.nome = 'Avaliação de Desempenho'
    @template_formulario.questoes = []
  end
  
  Quando('ele salva o template de formulário') do
    begin
      @template_formulario.salvar
      @criacao_sucesso = true
    rescue => e
      @criacao_sucesso = false
      @erro = e.message
    end
  end
  
  Quando('ele tenta salvar o template de formulário') do
    begin
      @template_formulario.salvar
      @criacao_sucesso = true
    rescue => e
      @criacao_sucesso = false
      @erro = e.message
    end
  end
  
  Então('o template deve ser criado com sucesso') do
    expect(@criacao_sucesso).to be true
  end
  
  Então('o template deve conter todas as questões fornecidas') do
    expect(@template_formulario.questoes).not_to be_empty
  end
  
  Então('a criação deve falhar') do
    expect(@criacao_sucesso).to be false
  end
  
  Então('uma mensagem de erro deve ser exibida informando que o nome é obrigatório') do
    expect(@erro).to include('Nome é obrigatório')
  end
  
  Então('uma mensagem de erro deve ser exibida informando que pelo menos uma questão é necessária') do
    expect(@erro).to include('Pelo menos uma questão é necessária')
  end
  
