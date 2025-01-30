Scenario: Criar um formulário de avaliação com sucesso (happy path)
    Dado que o Administrador deseja criar um formulário de avaliação baseado em um template existente
    E que ele escolhe um template de formulário válido
    E que ele seleciona uma ou mais turmas para associar ao formulário
    Quando ele salva o formulário de avaliação
    Então o formulário deve ser criado com sucesso
    E deve estar associado ao template e às turmas escolhidas

  Scenario: Falha ao criar um formulário de avaliação sem selecionar um template (sad path)
    Dado que o Administrador deseja criar um formulário de avaliação
    E que ele não seleciona um template de formulário
    Quando ele tenta salvar o formulário de avaliação
    Então a criação do formulário deve falhar
    E uma mensagem de erro deve ser exibida informando que o template é obrigatório

  Scenario: Falha ao criar um formulário de avaliação sem selecionar turmas (sad path)
    Dado que o Administrador deseja criar um formulário de avaliação
    E que ele seleciona um template de formulário válido
    E que ele não seleciona nenhuma turma
    Quando ele tenta salvar o formulário de avaliação
    Então a criação do formulário deve falhar
    E uma mensagem de erro deve ser exibida informando que pelo menos uma turma deve ser selecionada