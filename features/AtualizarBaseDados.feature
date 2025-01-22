Feature: Atualizar base de dados existente

  Como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do SIGAA
  A fim de corrigir a base de dados do sistema.

  Scenario: Atualizar base de dados com sucesso
  Dado que a base de dados já está configurada
  E os dados atuais do SIGAA estão disponíveis
  Quando eu solicito a atualização da base de dados
  Então a base de dados deve ser atualizada com os dados atuais do SIGAA
  E devo receber uma confirmação de que a atualização foi concluída com sucesso

  Scenario: Falha ao atualizar a base de dados devido à indisponibilidade do SIGAA
  Dado que a base de dados já está configurada
  E os dados atuais do SIGAA não estão disponíveis
  Quando eu solicito a atualização da base de dados
  Então a atualização deve falhar
  E devo receber uma mensagem de erro informando que o SIGAA está indisponível