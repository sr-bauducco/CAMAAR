Feature: Redefinição de senha

  Scenario: Clica no botão "Esqueci a senha" (Happy path)
    Given O e-mail existe na base de dados
    And O campo de e-mail está preenchido
    When O sistema envia o link de redefinição de senha para o e-mail cadastrado
    And Aparece a mensagem "Link para redefinição enviado para o e-mail informado"
    Then Exibe os campos para definir uma nova senha
    And Aparece a mensagem "Senha redefinida com sucesso"

  Scenario: Clica no botão "Esqueci a senha" (Sad path)
    Given O e-mail não existe na base de dados
    And O campo de e-mail está vazio
    When O sistema exibe a mensagem "Preencha o campo e-mail" ou "Não há este e-mail na base de dados"
    Then Redireciona o usuário para a página de login
