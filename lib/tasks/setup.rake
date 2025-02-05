namespace :setup do
  desc "Cria dados iniciais necessários para o sistema"
  task initial_data: :environment do
    # Criar departamento padrão
    department = Department.find_or_create_by!(name: "Departamento Padrão")

    # Criar usuário administrador
    admin = User.find_or_initialize_by(email: "admin@example.com")
    admin.update!(
      name: "Administrador",
      registration_number: "ADMIN001",
      role: 2, # admin
      department: department,
      password: "password123",
      password_confirmation: "password123"
    )

    # Criar usuário professor
    teacher = User.find_or_initialize_by(email: "teacher@example.com")
    teacher.update!(
      name: "Professor Exemplo",
      registration_number: "TEACHER001",
      role: 1, # teacher
      department: department,
      password: "password123",
      password_confirmation: "password123"
    )

    # Criar usuário estudante
    student = User.find_or_initialize_by(email: "student@example.com")
    student.update!(
      name: "Estudante Exemplo",
      registration_number: "STUDENT001",
      role: 0, # student
      department: department,
      password: "password123",
      password_confirmation: "password123"
    )

    # Criar disciplinas de exemplo
    subject1 = Subject.find_or_create_by!(name: "Programação 1", code: "PROG1", department: department)
    subject2 = Subject.find_or_create_by!(name: "Banco de Dados", code: "BD", department: department)
    subject3 = Subject.find_or_create_by!(name: "Engenharia de Software", code: "ES", department: department)

    # Criar turmas de exemplo
    class1 = SchoolClass.find_or_create_by!(subject: subject1, semester: "2024.1")
    class2 = SchoolClass.find_or_create_by!(subject: subject2, semester: "2024.1")
    class3 = SchoolClass.find_or_create_by!(subject: subject3, semester: "2024.1")

    # Associar professor às turmas
    Enrollment.find_or_create_by!(school_class: class1, teacher: teacher)
    Enrollment.find_or_create_by!(school_class: class2, teacher: teacher)
    Enrollment.find_or_create_by!(school_class: class3, teacher: teacher)

    # Matricular estudante nas turmas
    Enrollment.find_or_create_by!(school_class: class1, user: student)
    Enrollment.find_or_create_by!(school_class: class2, user: student)

    # Criar template de avaliação
    template = FormTemplate.find_or_create_by!(name: "Avaliação da Disciplina") do |t|
      t.department = department
      t.questions = [
        {
          text: "Como você avalia o conteúdo da disciplina?",
          answer_type: "text",
          required: true
        },
        {
          text: "De 0 a 10, qual nota você daria para a organização da disciplina?",
          answer_type: "number",
          required: true
        },
        {
          text: "Como você classifica a carga horária da disciplina?",
          answer_type: "multiple_choice",
          options: [ "Adequada", "Insuficiente", "Excessiva" ],
          required: true
        }
      ]
    end

    # Criar formulário para avaliação
    Form.find_or_create_by!(
      form_template: template,
      school_class: class2,
      target_audience: :students,
      status: :active
    )

    puts "Departamento padrão criado: #{department.name}"
    puts "\nDisciplinas criadas:"
    puts "- #{subject1.name} (#{subject1.code})"
    puts "- #{subject2.name} (#{subject2.code})"
    puts "- #{subject3.name} (#{subject3.code})"
    puts "\nTurmas criadas para o semestre 2024.1"
    puts "\nUsuários criados:"
    puts "\nAdministrador:"
    puts "Email: #{admin.email}"
    puts "Senha: password123"
    puts "\nProfessor:"
    puts "Email: #{teacher.email}"
    puts "Senha: password123"
    puts "\nEstudante:"
    puts "Email: #{student.email}"
    puts "Senha: password123"
    puts "\nAssociações:"
    puts "Professor leciona: PROG1, BD, ES"
    puts "Estudante matriculado em: PROG1, BD"
    puts "\nFormulários:"
    puts "- Avaliação da Disciplina (BD - 2024.1) para alunos"
  end
end
