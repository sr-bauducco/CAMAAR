Feature: Edição e deleção de templates de formulário

  Scenario: Editar um template de formulário com sucesso (happy path)
    Dado que o Administrador deseja editar um template de formulário existente
    E que ele fornece um novo nome e uma nova lista de questões
    Quando ele salva as alterações do template de formulário
    Então as alterações do template devem ser salvas com sucesso

  Scenario: Falha ao editar um template de formulário devido à ausência de nome (sad path)
    Dado que o Administrador deseja editar um template de formulário existente
    E que ele não fornece um nome para o template
    Quando ele tenta salvar as alterações do template de formulário
    Então a edição deve falhar
    E uma mensagem de erro deve ser exibida informando que o nome é obrigatório

  Scenario: Deletar um template de formulário com sucesso (happy path)
    Dado que o Administrador deseja excluir um template de formulário existente
    Quando ele deleta o template de formulário
    Então a exclusão do template deve ser realizada com sucesso