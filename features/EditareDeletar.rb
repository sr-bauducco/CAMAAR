Dado('que o Administrador deseja editar um template de formulário existente') do
    @template_formulario = TemplateFormulario.find_by(nome: 'Avaliação de Desempenho')
  end
  
  Dado('que ele fornece um novo nome e uma nova lista de questões') do
    @template_formulario.nome = 'Nova Avaliação'
    @template_formulario.questoes = ['Nova Questão 1', 'Nova Questão 2']
  end
  
  Dado('que ele não fornece um nome para o template') do
    @template_formulario.nome = nil
  end
  
  Dado('que o Administrador deseja excluir um template de formulário existente') do
    @template_formulario = TemplateFormulario.find_by(nome: 'Avaliação de Desempenho')
  end
  
  Quando('ele salva as alterações do template de formulário') do
    begin
      @template_formulario.salvar
      @edicao_sucesso = true
    rescue => e
      @edicao_sucesso = false
      @erro = e.message
    end
  end
  
  Quando('ele tenta salvar as alterações do template de formulário') do
    begin
      @template_formulario.salvar
      @edicao_sucesso = true
    rescue => e
      @edicao_sucesso = false
      @erro = e.message
    end
  end
  
  Quando('ele deleta o template de formulário') do
    begin
      @template_formulario.destroy
      @delecao_sucesso = true
    rescue => e
      @delecao_sucesso = false
      @erro = e.message
    end
  end
  
  Então('as alterações do template devem ser salvas com sucesso') do
    expect(@edicao_sucesso).to be true
    expect(@template_formulario.nome).to eq('Nova Avaliação')
  end
  
  Então('a edição deve falhar') do
    expect(@edicao_sucesso).to be false
  end
  
  Então('uma mensagem de erro deve ser exibida informando que o nome é obrigatório') do
    expect(@erro).to include('Nome é obrigatório')
  end
  
  Então('a exclusão do template deve ser realizada com sucesso') do
    expect(@delecao_sucesso).to be true
    expect(TemplateFormulario.find_by(nome: 'Avaliação de Desempenho')).to be_nil
  end
  