Feature: Sistema de definição de senha

  Scenario: Usuário define uma senha com sucesso a partir do e-mail de solicitação de cadastro (happy path)
    Dado que um usuário recebeu um e-mail de solicitação de cadastro com um link para definir a senha
    Quando ele acessa o link e fornece uma nova senha
    Então a senha deve ser definida com sucesso
    E o usuário deve conseguir acessar o sistema com a nova senha

  Scenario: Usuário tenta definir uma senha com um link inválido (sad path)
    Dado que um usuário tenta acessar um link inválido para definição de senha
    Quando ele tenta definir uma nova senha
    Então o sistema deve exibir uma mensagem de erro informando que o link é inválido ou expirado

  Scenario: Usuário tenta definir uma senha já utilizada anteriormente (sad path)
    Dado que um usuário recebeu um e-mail de solicitação de cadastro com um link válido
    E que ele já utilizou a senha fornecida anteriormente
    Quando ele tenta definir a mesma senha
    Então o sistema deve exibir uma mensagem de erro informando que a senha não pode ser reutilizada