Feature: Criar template de formulário

  Scenario: Criar um template de formulário com sucesso (happy path)
    Dado que o Administrador deseja criar um novo template de formulário
    E que ele fornece um nome e uma lista de questões válidas
    Quando ele salva o template de formulário
    Então o template deve ser criado com sucesso
    E o template deve conter todas as questões fornecidas

  Scenario: Falha ao criar um template de formulário devido a ausência de nome (sad path)
    Dado que o Administrador deseja criar um novo template de formulário
    E que ele não fornece um nome para o template
    Quando ele tenta salvar o template de formulário
    Então a criação deve falhar
    E uma mensagem de erro deve ser exibida informando que o nome é obrigatório

  Scenario: Falha ao criar um template de formulário devido a ausência de questões (sad path)
    Dado que o Administrador deseja criar um novo template de formulário
    E que ele não fornece nenhuma questão
    Quando ele tenta salvar o template de formulário
    Então a criação deve falhar
    E uma mensagem de erro deve ser exibida informando que pelo menos uma questão é necessária
