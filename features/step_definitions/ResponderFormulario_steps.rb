Given('que o usuário tem acesso a um formulário disponível no sistema') do
  visit '/formularios/novo' # Ajuste o caminho para a página do formulário
end

When('o usuário preenche todos os campos obrigatórios e envia o formulário') do
  fill_in 'nome', with: 'João da Silva'
  fill_in 'email', with: 'joao.silva@example.com'
  fill_in 'mensagem', with: 'Gostei muito do sistema!'
  click_button 'Enviar'
end

Then('a resposta do formulário deve ser salva no sistema') do
  expect(FormularioResposta.last.nome).to eq('João da Silva')
  expect(FormularioResposta.last.email).to eq('joao.silva@example.com')
end

Then('uma mensagem de confirmação deve ser exibida') do
  expect(page).to have_content('Formulário enviado com sucesso!')
end

Given('há campos obrigatórios não preenchidos') do
  # Não preenchemos os campos obrigatórios neste cenário
end

When('o usuário tenta enviar o formulário') do
  click_button 'Enviar'
end

Then('o envio deve falhar') do
  expect(page).to have_content('Erro: Preencha os campos obrigatórios.')
end

Then('uma mensagem de erro deve ser exibida indicando os campos obrigatórios não preenchidos') do
  expect(page).to have_content('Os campos Nome e Email são obrigatórios.')
end
