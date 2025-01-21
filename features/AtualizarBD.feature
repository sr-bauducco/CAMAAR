Feature: Atualização da base de dados com dados do SIGAA

  Scenario: Atualizar a base de dados com os dados mais recentes do SIGAA com sucesso (happy path)
  Dado que a base de dados contém dados desatualizados de turmas, matérias e participantes
  E que os dados mais recentes do SIGAA estão disponíveis no repositório
  Quando o Administrador atualiza a base de dados com os dados do SIGAA
  Entao os dados desatualizados devem ser substituídos pelos dados mais recentes
  E os dados de turmas, matérias e participantes devem refletir as últimas informações do SIGAA

  Scenario: Falha ao atualizar a base de dados devido a dados corrompidos do SIGAA (sad path)
  Dado que a base de dados contém dados desatualizados de turmas, matérias e participantes
  E que os dados mais recentes do SIGAA estão disponíveis no repositório, mas estão corrompidos
  Quando o Administrador tenta atualizar a base de dados com os dados do SIGAA
  Entao a atualização deve falhar
  E uma mensagem de erro indicando que os dados estão corrompidos deve ser exibida
