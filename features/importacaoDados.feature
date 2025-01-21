Feature: Importação de dados do SIGAA

  Scenario: Importar dados de turmas, matérias e participantes do SIGAA com sucesso (happy path)
  Dado que os dados de turmas, matérias e participantes do SIGAA não existem na base de dados
  Quando o Administrador importa os dados de SIGAA do repositório
  Entao os dados de turmas, matérias e participantes devem ser importados e salvos na base de dados
  E nenhum dado existente deve ser sobrescrito

  Scenario: Falha ao importar dados do SIGAA devido a erro no formato dos dados (sad path)
  Dado que os dados de turmas, matérias e participantes do SIGAA não existem na base de dados
  E o arquivo JSON contém dados com formato inválido
  Quando o Administrador tenta importar os dados de SIGAA do repositório
  Entao a importação deve falhar
  E uma mensagem de erro indicando o problema com o formato do arquivo deve ser exibida
