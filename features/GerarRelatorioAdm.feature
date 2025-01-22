Feature: Gerar Relatório do Administrador

	Scenario: Gerar relatório de atividades do sistema com sucesso (happy path)
	Dado que o administrador tem permissão para acessar a funcionalidade de geração de relatórios
	E há dados disponíveis para gerar o relatório
	Quando o administrador solicita a geração do relatório de atividades
	Então o relatório deve ser gerado com os dados disponíveis
	E o arquivo deve ser disponibilizado para download

	Scenario: Falha ao gerar relatório devido à ausência de dados (sad path)
	Dado que o administrador tenta gerar um relatório de atividades
	E não há dados disponíveis no período solicitado
	Quando o administrador solicita a geração do relatório
	Então o sistema deve indicar que não há dados para gerar o relatório
	E nenhuma saída de relatório deve ser gerada

