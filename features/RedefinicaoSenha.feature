Feature: Redefinição de senha

  Scenario: Usuário solicita redefinição de senha com sucesso (happy path)
    Dado que um usuário cadastrado deseja redefinir sua senha
    E que ele solicita a redefinição informando seu e-mail
    Quando o sistema envia um e-mail com o link de redefinição
    Então o usuário deve receber um e-mail contendo o link para redefinir sua senha

  Scenario: Usuário redefine a senha com sucesso através do link recebido (happy path)
    Dado que um usuário recebeu um e-mail com um link válido para redefinição de senha
    Quando ele acessa o link e fornece uma nova senha
    Então a senha deve ser atualizada com sucesso
    E o usuário deve conseguir acessar o sistema com a nova senha

  Scenario: Usuário tenta redefinir a senha com um link inválido (sad path)
    Dado que um usuário tenta acessar um link inválido para redefinição de senha
    Quando ele tenta redefinir a senha
    Então o sistema deve exibir uma mensagem de erro informando que o link é inválido ou expirado

  Scenario: Usuário tenta solicitar redefinição de senha com um e-mail não cadastrado (sad path)
    Dado que um usuário não cadastrado tenta solicitar redefinição de senha
    Quando ele informa um e-mail não existente no sistema
    Então o sistema deve exibir uma mensagem de erro informando que o e-mail não está cadastrado