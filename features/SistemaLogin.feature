Feature: Sistema de Login

  Scenario: Usuário faz login com sucesso utilizando e-mail e senha (happy path)
    Dado que um usuário cadastrado existe com um e-mail e senha válidos
    Quando ele tenta acessar o sistema com o e-mail e senha corretos
    Então o login deve ser realizado com sucesso
    E ele deve ser redirecionado para a página inicial do sistema

  Scenario: Usuário faz login com sucesso utilizando matrícula e senha (happy path)
    Dado que um usuário cadastrado existe com uma matrícula e senha válidos
    Quando ele tenta acessar o sistema com a matrícula e senha corretos
    Então o login deve ser realizado com sucesso
    E ele deve ser redirecionado para a página inicial do sistema

  Scenario: Usuário insere credenciais inválidas e falha no login (sad path)
    Dado que um usuário não cadastrado tenta acessar o sistema
    Quando ele insere um e-mail ou matrícula e senha incorretos
    Então o login deve falhar
    E uma mensagem de erro deve ser exibida informando credenciais inválidas

  Scenario: Usuário administrador faz login e visualiza opções de gerenciamento (happy path)
    Dado que um usuário administrador cadastrado existe com um e-mail e senha válidos
    Quando ele tenta acessar o sistema com o e-mail e senha corretos
    Então o login deve ser realizado com sucesso
    E ele deve visualizar a opção de gerenciamento no menu lateral