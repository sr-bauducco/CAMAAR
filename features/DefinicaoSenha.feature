Feature: Sistema de definição de senha

  Scenario: Clicou no link de solicitação de cadastro (Happy path)
    Given O e-mail está cadastrado na base de dados
    And O link é válido e não expirou
    When O usuário clica no link de definição de senha
    Then O sistema permite que o usuário cadastre uma nova senha
    And A nova senha é armazenada na base de dados

  Scenario: Tentativa de definir senha com link inválido ou expirado (Sad path)
    Given O e-mail está cadastrado na base de dados
    And O link é inválido ou já expirou
    When O usuário tenta clicar no link de definição de senha
    Then O sistema exibe a mensagem "Link inválido ou expirado"
    And O usuário é redirecionado para a página de solicitação de um novo link
