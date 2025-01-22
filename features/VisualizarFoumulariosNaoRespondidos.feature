Feature: Visualização de Formulários para Responder
  Para escolher qual formulário irei responder
  Como um Participante de uma turma
  Eu quero visualizar os formulários não respondidos das turmas em que estou matriculado

  Scenario: Visualizar formulários não respondidos
    Given o Participante acessa o sistema
      And está matriculado em turmas com formulários disponíveis
    When ele navega até a página "Formulários"
    Then ele deve ver uma lista de formulários não respondidos

  Scenario: Nenhum formulário disponível
    Given o Participante acessa o sistema
      And não há formulários disponíveis para as turmas em que está matriculado
    When ele navega até a página "Formulários"
    Then ele deve ver a mensagem "Nenhum formulário disponível para responder"

  Scenario: Tentar acessar formulário já respondido
    Given o Participante acessa o sistema
      And está matriculado em turmas com formulários
      And já respondeu um formulário
    When ele tenta acessar o formulário respondido
    Then ele deve ver a mensagem "Você já respondeu este formulário"
