Dado('que os dados de participantes de turmas do SIGAA estão disponíveis no repositório') do
  # Simula a disponibilidade dos dados de participantes de turmas do SIGAA
  @dados_participantes = [
    { nome: 'João Silva', email: 'joao.silva@email.com', turma: 'Turma A' },
    { nome: 'Maria Souza', email: 'maria.souza@email.com', turma: 'Turma B' }
  ]
end

Dado('que os usuários ainda não existem na base de dados') do
  # Garante que os dados de participantes ainda não estão cadastrados
  @usuarios_existentes = Participante.all
  expect(@usuarios_existentes).to be_empty
end

Dado('que um dos usuários tem dados incompletos') do
  # Simula dados incompletos para um dos usuários
  @dados_incompletos = [
    { nome: 'Carlos Oliveira', email: '', turma: 'Turma C' } # Email vazio
  ]
end

Quando('o Administrador importa os dados de usuários do SIGAA') do
  # Simula a importação dos dados de usuários
  @dados_participantes.each do |usuario|
    begin
      Participante.create!(nome: usuario[:nome], email: usuario[:email], turma: usuario[:turma])
      @importacao_sucesso = true
    rescue => e
      @importacao_sucesso = false
      @erro = e.message
    end
  end
end

Quando('o Administrador tenta importar os dados de usuários do SIGAA') do
  # Simula a tentativa de importação de dados com um usuário incompleto
  @dados_incompletos.each do |usuario|
    begin
      Participante.create!(nome: usuario[:nome], email: usuario[:email], turma: usuario[:turma])
      @importacao_sucesso = true
    rescue => e
      @importacao_sucesso = false
      @erro = e.message
    end
  end
end

Entao('os participantes devem ser cadastrados no sistema CAMAAR') do
  # Verifique se os participantes foram cadastrados
  expect(Participante.count).to eq(2)
  expect(Participante.find_by(nome: 'João Silva')).not_to be_nil
  expect(Participante.find_by(nome: 'Maria Souza')).not_to be_nil
end

Entao('os usuários existentes não devem ser duplicados') do
  # Verifique que não existem usuários duplicados
  expect(Participante.count).to eq(2)  # Nenhum usuário duplicado
end

Entao('a importação deve falhar para o usuário com dados incompletos') do
  # Verifique se a importação falhou
  expect(@importacao_sucesso).to be false
end

Entao('uma mensagem de erro indicando o problema com o dado incompleto deve ser exibida') do
  # Verifique se a mensagem de erro inclui dados incompletos
  expect(@erro).to include("Email can't be blank")
end
