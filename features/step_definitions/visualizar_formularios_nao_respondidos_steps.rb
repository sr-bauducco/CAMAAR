Given('o Participante acessa o sistema') do
  @turma = Turma.create!(nome: 'Turma Teste', departamento: @dept_computacao)
  @participante = Participante.create!(
    email: 'participante@example.com',
    password: 'password123',
    password_confirmation: 'password123',
    turma: @turma
  )
  visit '/login'
  fill_in 'email', with: 'participante@example.com'
  fill_in 'password', with: 'password123'
  click_button 'Entrar'
end

Given('está matriculado em turmas com formulários disponíveis') do
  @formulario = Formulario.create!(
    titulo: 'Formulário de Teste',
    descricao: 'Descrição do formulário',
    tipo: 'Discentes',
    turma: @turma
  )
end

Given('está matriculado em turmas com formulários') do
  @formulario = Formulario.create!(
    titulo: 'Formulário de Teste',
    descricao: 'Descrição do formulário',
    tipo: 'Discentes',
    turma: @turma
  )
end

Given('não há formulários disponíveis para as turmas em que está matriculado') do
  @turma.update!(nome: 'Turma Sem Formulários')
end

Given('já respondeu um formulário') do
  @resposta = Resposta.create!(
    participante: @participante,
    formulario: @formulario
  )
end

When('ele tenta acessar o formulário respondido') do
  visit formulario_path(@formulario)
end

Then('ele deve ver uma lista de formulários não respondidos') do
  expect(page).to have_content('Formulários Disponíveis')
  expect(page).to have_content(@formulario.titulo)
  expect(page).to have_content(@formulario.descricao)
end
