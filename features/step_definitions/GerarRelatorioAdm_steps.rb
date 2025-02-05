Given('que o administrador tem permissão para acessar a funcionalidade de geração de relatórios') do
  @admin = User.create!(email: 'admin@example.com', role: 'admin', password: 'password')
  login_as(@admin)
  visit '/relatorios'
end

Given('há dados disponíveis para gerar o relatório') do
  # Insere dados para serem usados no relatório
  ActivityLog.create!(descricao: 'Ação 1', created_at: 1.day.ago)
  ActivityLog.create!(descricao: 'Ação 2', created_at: 2.days.ago)
end

When('o administrador solicita a geração do relatório de atividades') do
  click_button 'Gerar Relatório'
end

Then('o relatório deve ser gerado com os dados disponíveis') do
  expect(page).to have_content('Relatório Gerado com Sucesso')
  expect(page).to have_content('Ação 1')
  expect(page).to have_content('Ação 2')
end

Then('o arquivo deve ser disponibilizado para download') do
  expect(page).to have_link('Baixar Relatório')
end

Given('não há dados disponíveis no período solicitado') do
  # Não adiciona registros no banco de dados
end

Then('o sistema deve indicar que não há dados para gerar o relatório') do
  expect(page).to have_content('Nenhum dado disponível para gerar o relatório.')
end

Then('nenhuma saída de relatório deve ser gerada') do
  expect(page).not_to have_link('Baixar Relatório')
end
