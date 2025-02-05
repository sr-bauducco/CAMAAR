namespace :sigaa do
  desc "Importa dados do SIGAA a partir dos arquivos JSON"
  task import: :environment do
    # Carrega os arquivos JSON
    classes_json = JSON.parse(File.read(Rails.root.join("classes.json")))
    members_json = JSON.parse(File.read(Rails.root.join("class_members.json")))

    # Cria departamento padrão para CIC
    department = Department.find_or_create_by!(name: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")

    # Processa disciplinas e turmas
    classes_json.each do |class_data|
      # Cria ou atualiza a disciplina
      subject = Subject.find_or_create_by!(code: class_data["code"]) do |s|
        s.name = class_data["name"]
        s.department = department
      end

      # Cria ou atualiza a turma
      school_class = SchoolClass.find_or_create_by!(
        subject: subject,
        semester: class_data["class"]["semester"]
      )
    end

    # Processa membros das turmas
    members_json.each do |class_members|
      # Encontra a disciplina e turma
      subject = Subject.find_by!(code: class_members["code"])
      school_class = SchoolClass.find_by!(
        subject: subject,
        semester: class_members["semester"]
      )

      # Processa o professor
      teacher_data = class_members["docente"]
      teacher = User.find_or_initialize_by(registration_number: teacher_data["usuario"])
      is_new_teacher = teacher.new_record?
      teacher.assign_attributes(
        name: teacher_data["nome"],
        email: teacher_data["email"],
        role: :teacher,
        department: department,
        force_password_change: is_new_teacher
      )
      # Define senha temporária se for um novo usuário
      if is_new_teacher
        temp_password = SecureRandom.hex(8)
        teacher.password = temp_password
        teacher.password_confirmation = temp_password
        puts "Nova senha para professor #{teacher.name}: #{temp_password}"
      end
      teacher.save!

      # Cria matrícula do professor
      Enrollment.find_or_create_by!(
        school_class: school_class,
        teacher: teacher,
        role: :teacher
      )

      # Processa os alunos
      class_members["dicente"].each do |student_data|
        student = User.find_or_initialize_by(registration_number: student_data["matricula"])
        is_new_student = student.new_record?
        student.assign_attributes(
          name: student_data["nome"],
          email: student_data["email"],
          role: :student,
          department: department,
          force_password_change: is_new_student
        )
        # Define senha temporária se for um novo usuário
        if is_new_student
          temp_password = SecureRandom.hex(8)
          student.password = temp_password
          student.password_confirmation = temp_password
          puts "Nova senha para aluno #{student.name}: #{temp_password}"
        end
        student.save!

        # Cria matrícula do aluno
        Enrollment.find_or_create_by!(
          school_class: school_class,
          user: student,
          role: :student
        )
      end
    end

    puts "Importação concluída com sucesso!"
  end
end
