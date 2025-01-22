Given('o Administrador acessa a página de criação de formulários') do
  visit '/formularios/novo'
end

When('ele escolhe a opção {string}') do |opcao|
  choose opcao
end

When('seleciona uma turma') do
  select 'Turma A', from: 'turma'
end

When('preenche os campos obrigatórios') do
  fill_in 'titulo', with: 'Formulário de Avaliação'
  fill_in 'descricao', with: 'Descrição do formulário de avaliação'
end

When('ele não preenche os campos obrigatórios') do
  # Leave fields empty
  fill_in 'titulo', with: ''
  fill_in 'descricao', with: ''
end

When('clica no botão {string}') do |botao|
  click_button botao
end

Then('ele deve ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
