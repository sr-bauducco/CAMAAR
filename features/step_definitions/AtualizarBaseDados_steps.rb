Dado('que a base de dados já está configurada') do
  # Configuração inicial da base de dados
  @database = Database.new
  expect(@database.configured?).to be true
end

Dado('os dados atuais do SIGAA estão disponíveis') do

  json_file_path = File.expand_path('../../classes_members.json', __FILE__)
  file_content = File.read(json_file_path)
  @sigaa_data = JSON.parse(file_content, symbolize_names: true)

  allow(SigaaAPI).to receive(:get_data).and_return(@sigaa_data)

  # Verifica se os dados foram carregados corretamente
  expect(@sigaa_data).not_to be_empty
end

Quando('eu solicito a atualização da base de dados') do
  # Tenta atualizar a base de dados e captura qualquer erro
  begin
    @update_result = @database.update(SigaaAPI.get_data)
  rescue => e
    @error_message = e.message
    @update_result = nil
  end
end

Então('a base de dados deve ser atualizada com os dados atuais do SIGAA') do
  # Verifica se a base de dados foi atualizada corretamente
  expect(@database.updated_with?(@sigaa_data)).to be true
end

Então('devo receber uma confirmação de que a atualização foi concluída com sucesso') do
  # Verifica a mensagem de sucesso
  expect(@update_result).to eq('Atualização concluída com sucesso')
end

#CENARIO TRISTE

Dado('os dados atuais do SIGAA não estão disponíveis') do
  # Simula a indisponibilidade dos dados do SIGAA
  allow(SigaaAPI).to receive(:get_data).and_raise('SIGAA indisponível')
end

Quando('eu solicito a atualização da base de dados') do
  # Tenta atualizar a base de dados e captura qualquer erro
  begin
    @update_result = @database.update(SigaaAPI.get_data)
  rescue => e
    @error_message = e.message
    @update_result = nil
  end
end

Então('a atualização deve falhar') do
  # Verifica que a atualização não foi realizada
  expect(@update_result).to be_nil
end

Então('devo receber uma mensagem de erro informando que o SIGAA está indisponível') do
  # Verifica a mensagem de erro retornada
  expect(@error_message).to eq('SIGAA indisponível')
end
