Dado('que a base de dados contém dados desatualizados de turmas, matérias e participantes') do
  # Aqui você pode simular dados desatualizados, por exemplo:
  @turma_antiga = Turma.create(nome: 'Turma Antiga', ano: 2022)
  @materia_antiga = Materia.create(nome: 'Matéria Antiga', codigo: 'MAT001')
  @participante_antigo = Participante.create(nome: 'Participante Antigo', turma: @turma_antiga)
end

Dado('que os dados mais recentes do SIGAA estão disponíveis no repositório') do
  # Simula a disponibilidade de dados mais recentes do SIGAA
  @dados_atualizados = {
    turmas: [
      { nome: 'Turma Nova', ano: 2023 }
    ],
    materias: [
      { nome: 'Matéria Nova', codigo: 'MAT002' }
    ],
    participantes: [
      { nome: 'Participante Novo', turma: 'Turma Nova' }
    ]
  }
end

Dado('que os dados mais recentes do SIGAA estão disponíveis no repositório, mas estão corrompidos') do
  # Simula a disponibilidade de dados corrompidos
  @dados_corrompidos = {
    turmas: [
      { nome: nil, ano: nil }
    ],
    materias: [
      { nome: nil, codigo: nil }
    ],
    participantes: [
      { nome: nil, turma: nil }
    ]
  }
end

Quando('o Administrador atualiza a base de dados com os dados do SIGAA') do
  # Aqui você pode simular a atualização da base de dados
  begin
    @turma_antiga.update(nome: @dados_atualizados[:turmas].first[:nome], ano: @dados_atualizados[:turmas].first[:ano])
    @materia_antiga.update(nome: @dados_atualizados[:materias].first[:nome], codigo: @dados_atualizados[:materias].first[:codigo])
    @participante_antigo.update(nome: @dados_atualizados[:participantes].first[:nome], turma: @turma_antiga)
    @atualizacao_sucesso = true
  rescue => e
    @atualizacao_sucesso = false
    @erro = e.message
  end
end

Quando('o Administrador tenta atualizar a base de dados com os dados do SIGAA') do
  # Simula a tentativa de atualização com dados corrompidos
  begin
    @turma_antiga.update(nome: @dados_corrompidos[:turmas].first[:nome], ano: @dados_corrompidos[:turmas].first[:ano])
    @materia_antiga.update(nome: @dados_corrompidos[:materias].first[:nome], codigo: @dados_corrompidos[:materias].first[:codigo])
    @participante_antigo.update(nome: @dados_corrompidos[:participantes].first[:nome], turma: @turma_antiga)
    @atualizacao_sucesso = true
  rescue => e
    @atualizacao_sucesso = false
    @erro = e.message
  end
end

Entao('os dados desatualizados devem ser substituídos pelos dados mais recentes') do
  # Verifique se os dados foram atualizados corretamente
  expect(@turma_antiga.nome).to eq('Turma Nova')
  expect(@materia_antiga.nome).to eq('Matéria Nova')
  expect(@participante_antigo.nome).to eq('Participante Novo')
end

Entao('os dados de turmas, matérias e participantes devem refletir as últimas informações do SIGAA') do
  # Verifique se as informações dos dados refletem o SIGAA
  expect(@turma_antiga.ano).to eq(2023)
  expect(@materia_antiga.codigo).to eq('MAT002')
end

Entao('a atualização deve falhar') do
  # Verifique se a atualização falhou
  expect(@atualizacao_sucesso).to be false
end

Entao('uma mensagem de erro indicando que os dados estão corrompidos deve ser exibida') do
  # Verifique se a mensagem de erro de dados corrompidos foi exibida
  expect(@erro).to include('corrompidos')
end
