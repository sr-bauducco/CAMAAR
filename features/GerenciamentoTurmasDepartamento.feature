Feature: Gerenciamento de Turmas por Departamento
  Para avaliar o desempenho das turmas no semestre atual
  Como um Administrador
  Eu quero gerenciar somente as turmas do departamento ao qual pertenço

  @with_turmas
  Scenario: Visualizar turmas do departamento
    Given o Administrador acessa o sistema
    When ele navega até a página "Gerenciar Turmas"
    Then ele deve ver apenas as turmas pertencentes ao seu departamento

  @with_turmas
  Scenario: Tentativa de acessar turmas de outro departamento
    Given o Administrador acessa o sistema
    When ele tenta acessar uma turma de outro departamento
    Then ele deve ver a mensagem "Acesso negado: Você não tem permissão para gerenciar esta turma"

  Scenario: Nenhuma turma cadastrada para o departamento
    Given o Administrador acessa o sistema
    When ele navega até a página "Gerenciar Turmas"
    Then ele deve ver a mensagem "Nenhuma turma cadastrada para o seu departamento"
