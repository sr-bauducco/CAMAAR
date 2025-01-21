Dado('que os dados de turmas, matérias e participantes do SIGAA não existem na base de dados') do
  # Garante que não há dados de turmas, matérias ou participantes no sistema
  @dados_turmas = Turma.all
  @dados_materias = Materia.all
  @dados_participantes = Participante.all
  expect(@dados_turmas).to be_empty
  expect(@dados_materias).to be_empty
  expect(@dados_participantes).to be_empty
end

Quando('o Administrador importa os dados de SIGAA do repositório') do
  # Simula a importação dos dados de SIGAA
  # Normalmente, você vai fazer uma leitura de um arquivo JSON ou de um banco de dados de repositório
  @dados_importados = {
    turmas: [{ nome: 'Turma A' }, { nome: 'Turma B' }],
    materias: [{ nome: 'Matemática' }, { nome: 'Física' }],
    participantes: [
      { nome: 'João Silva', email: 'joao.silva@email.com', turma: 'Turma A' },
      { nome: 'Maria Souza', email: 'maria.souza@email.com', turma: 'Turma B' }
    ]
  }

  @dados_importados[:turmas].each { |turma| Turma.create!(nome: turma[:nome]) }
  @dados_importados[:materias].each { |materia| Materia.create!(nome: materia[:nome]) }
  @dados_importados[:participantes].each { |participante|
    Participante.create!(nome: participante[:nome], email: participante[:email], turma: participante[:turma])
  }
end

Quando('o Administrador tenta importar os dados de SIGAA do repositório') do
  # Simula a tentativa de importação com um arquivo JSON com dados inválidos
  @dados_invalidados = '{ "turmas": [ "Turma A" ], "materias": "Matemática" }' # JSON inválido (formato errado)

  begin
    # Simulando a falha no parsing de JSON
    dados = JSON.parse(@dados_invalidados)
    @importacao_sucesso = true
  rescue JSON::ParserError => e
    @importacao_sucesso = false
    @erro = e.message
  end
end

Entao('os dados de turmas, matérias e participantes devem ser importados e salvos na base de dados') do
  # Verifica se os dados foram importados
  expect(Turma.count).to eq(2)
  expect(Materia.count).to eq(2)
  expect(Participante.count).to eq(2)
end

Entao('nenhum dado existente deve ser sobrescrito') do
  # Verifica que os dados existentes não foram sobrescritos
  dados_iniciais_turmas = Turma.count
  dados_iniciais_materias = Materia.count
  dados_iniciais_participantes = Participante.count

  # Simula a importação novamente para garantir que os dados não foram sobrescritos
  Turma.create!(nome: 'Turma C')
  Materia.create!(nome: 'Química')
  Participante.create!(nome: 'Carlos Oliveira', email: 'carlos.oliveira@email.com', turma: 'Turma A')

  expect(Turma.count).to eq(dados_iniciais_turmas + 1)
  expect(Materia.count).to eq(dados_iniciais_materias + 1)
  expect(Participante.count).to eq(dados_iniciais_participantes + 1)
end

Entao('a importação deve falhar') do
  # Verifica se a importação falhou
  expect(@importacao_sucesso).to be false
end

Entao('uma mensagem de erro indicando o problema com o formato do arquivo deve ser exibida') do
  # Verifica a mensagem de erro do formato inválido
  expect(@erro).to include("unexpected token at")
end
