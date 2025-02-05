Feature: Criação de Formulário para Docentes ou Discentes
  Para avaliar o desempenho de uma matéria
  Como um Administrador
  Eu quero criar um formulário para os docentes ou discentes de uma turma

  Scenario: Criar formulário para docentes
    Given o Administrador acessa a página de criação de formulários
    When ele escolhe a opção "Docentes"
    And seleciona uma turma
    And preenche os campos obrigatórios
    And clica no botão "Criar Formulário"
    Then ele deve ver a mensagem "Formulário criado com sucesso"

  Scenario: Criar formulário para discentes
    Given o Administrador acessa a página de criação de formulários
    When ele escolhe a opção "Discentes"
    And seleciona uma turma
    And preenche os campos obrigatórios
    And clica no botão "Criar Formulário"
    Then ele deve ver a mensagem "Formulário criado com sucesso"

  Scenario: Tentativa de criar formulário sem preencher os campos obrigatórios
    Given o Administrador acessa a página de criação de formulários
    When ele não preenche os campos obrigatórios
    And clica no botão "Criar Formulário"
    Then ele deve ver a mensagem "Erro: Todos os campos obrigatórios devem ser preenchidos"
