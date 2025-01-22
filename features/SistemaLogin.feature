Feature: Sistema de Login

  Scenario: Logar no sistema (happy path)
    Given Está logado como dicente ou docente
    When O usuário preenche os campos e-mail, senha e um tipo denominado dicente ou docente
    And Depois do preenchimento, o usuário clica no botão Logar
    Then Após logar, o sistema exibirá "Logado com sucesso"


  Scenario: Falha ao logar no sistema (sad path)
    Given Falha no login do usuário
    When O usuário não preenche corretamente o e-mail, senha ou tipo (docente ou dicente)
    And Os dados não existem na base de dados
    Then O sistema exibirá "E-mail e/ou senha incorretos"
