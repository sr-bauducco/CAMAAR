Given('o Administrador acessa o sistema') do
  visit '/login'
  fill_in 'email', with: 'admin@example.com'
  fill_in 'password', with: 'password123'
  click_button 'Entrar'
end

When('ele navega até a página {string}') do |pagina|
  click_link pagina
end

When('ele tenta acessar uma turma de outro departamento') do
  visit "/turmas/#{@turma_mat.id}"
end

Then('ele deve ver apenas as turmas pertencentes ao seu departamento') do
  expect(page).to have_content('Turmas do Departamento de Computação')
  expect(page).to have_content('Programação 1')
  expect(page).to have_content('Estrutura de Dados')
  expect(page).not_to have_content('Cálculo 1')
end
