Feature: Visualização de resultados dos formulários

  Scenario: Administrador visualiza a lista de formulários criados (happy path)
    Dado que existem formulários criados no sistema
    Quando o Administrador acessa a página de visualização de formulários
    Então ele deve ver a lista de formulários criados

  Scenario: Administrador visualiza os detalhes de um formulário específico (happy path)
    Dado que um formulário específico possui respostas registradas
    Quando o Administrador acessa os detalhes desse formulário
    Então ele deve ver todas as respostas associadas ao formulário

  Scenario: Administrador tenta visualizar um formulário inexistente (sad path)
    Dado que um formulário não existe no sistema
    Quando o Administrador tenta acessá-lo
    Então o sistema deve exibir uma mensagem de erro informando que o formulário não foi encontrado