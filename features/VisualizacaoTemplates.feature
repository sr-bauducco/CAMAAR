Feature: Visualização dos templates criados

  Scenario: Administrador visualiza a lista de templates criados (happy path)
    Dado que existem templates de formulário criados no sistema
    Quando o Administrador acessa a página de visualização de templates
    Então ele deve ver a lista de templates criados

  Scenario: Administrador visualiza os detalhes de um template específico (happy path)
    Dado que um template específico existe no sistema
    Quando o Administrador acessa os detalhes desse template
    Então ele deve ver todas as informações associadas ao template

  Scenario: Administrador tenta visualizar um template inexistente (sad path)
    Dado que um template não existe no sistema
    Quando o Administrador tenta acessá-lo
    Então o sistema deve exibir uma mensagem de erro informando que o template não foi encontrado