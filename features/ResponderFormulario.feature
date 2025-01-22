Feature: Responder Formulário

	Scenario: Responder um formulário com sucesso (happy path)
	Dado que o usuário tem acesso a um formulário disponível no sistema
	Quando o usuário preenche todos os campos obrigatórios e envia o formulário
	Então a resposta do formulário deve ser salva no sistema
	E uma mensagem de confirmação deve ser exibida

	Scenario: Falha ao enviar o formulário devido a campos obrigatórios não preenchidos (sad path)
	Dado que o usuário está preenchendo um formulário
	E há campos obrigatórios não preenchidos
	Quando o usuário tenta enviar o formulário
	Então o envio deve falhar
	E uma mensagem de erro deve ser exibida indicando os campos obrigatórios não preenchidos