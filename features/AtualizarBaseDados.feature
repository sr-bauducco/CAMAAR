Feature: Atualizar base de dados existente

  Scenario: Atualizar base de dados com sucesso
  Given que a base de dados já está configurada
  And os dados atuais do SIGAA estão disponíveis
  When eu solicito a atualização da base de dados
  Then a base de dados deve ser atualizada com os dados atuais do SIGAA
  And devo receber uma confirmação de que a atualização foi concluída com sucesso

  Scenario: Falha ao atualizar a base de dados devido à indisponibilidade do SIGAA
  Given que a base de dados já está configurada
  And os dados atuais do SIGAA não estão disponíveis
  When eu solicito a atualização da base de dados
  Then a atualização deve falhar
  And devo receber uma mensagem de erro informando que o SIGAA está indisponível