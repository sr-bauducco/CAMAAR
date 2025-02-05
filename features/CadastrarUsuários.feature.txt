Feature: Cadastro de usuários do sistema

  Scenario: Cadastrar participantes de turmas do SIGAA com sucesso ao importar dados de usuários novos (happy path)
  Dado que os dados de participantes de turmas do SIGAA estão disponíveis no repositório
  E que os usuários ainda não existem na base de dados
  Quando o Administrador importa os dados de usuários do SIGAA
  Entao os participantes devem ser cadastrados no sistema CAMAAR
  E os usuários existentes não devem ser duplicados

  Scenario: Falha ao cadastrar usuários devido a dados incompletos (sad path)
  Dado que os dados de participantes de turmas do SIGAA estão disponíveis no repositório
  E que um dos usuários tem o email incompleto
  Quando o Administrador tenta importar os dados de usuários do SIGAA
  Entao a importação deve falhar para o usuário com email incompleto
  E uma mensagem de erro indicando o problema com o dado incompleto deve ser exibida
