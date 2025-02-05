Feature: Redefinir senha através do e-mail

  Scenario: Solicitar redefinição de senha e receber e-mail
  Dado que eu estou na página de login
  Quando eu solicito a redefinição de senha
  Então eu devo receber um e-mail com o link para redefinir minha senha

  Scenario: Redefinir senha com sucesso após receber o e-mail
  Dado que eu recebi um e-mail com o link de redefinição de senha
  Quando eu clico no link de redefinição
  E eu insiro uma nova senha válida
  Então minha senha deve ser atualizada com sucesso
  E eu devo ser redirecionado para a página de login

  Scenario: Solicitar redefinição de senha e não receber e-mail devido a erro
  Dado que eu estou na página de login
  Quando eu solicito a redefinição de senha com um e-mail inválido
  Então eu não devo receber um e-mail com o link para redefinir minha senha
  E eu devo ver uma mensagem de erro informando que o e-mail não foi enviado
