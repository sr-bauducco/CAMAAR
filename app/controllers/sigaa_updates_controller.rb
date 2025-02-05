class SigaaUpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def new
    # Limpa mensagens antigas
    flash.delete(:log)
  end

  def create
    # Inicializa contadores
    @stats = {
      subjects_updated: 0,
      classes_updated: 0,
      new_teachers: 0,
      existing_teachers: 0,
      new_students: 0,
      existing_students: 0,
      removed_enrollments: 0
    }
    @new_passwords = []

    if params[:classes_json].nil? || params[:members_json].nil?
      redirect_to new_sigaa_update_path, alert: "Por favor, selecione os arquivos JSON do SIGAA"
      return
    end

    begin
      classes_json = JSON.parse(params[:classes_json].read)
      members_json = JSON.parse(params[:members_json].read)

      # Usa o departamento do usuário atual
      department = current_user.department

      # Processa disciplinas e turmas
      classes_json.each do |class_data|
        # Verifica se a disciplina pertence ao departamento do usuário
        next unless class_data["department"] == department.name

        # Cria ou atualiza a disciplina
        subject = Subject.find_or_create_by!(code: class_data["code"]) do |s|
          s.name = class_data["name"]
          s.department = department
        end

        # Atualiza nome da disciplina se necessário
        if subject.name != class_data["name"]
          subject.update!(name: class_data["name"])
          @stats[:subjects_updated] += 1
        end

        # Cria ou atualiza a turma
        SchoolClass.find_or_create_by!(
          subject: subject,
          semester: class_data["class"]["semester"]
        )
        @stats[:classes_updated] += 1
      end

      # Processa membros das turmas
      members_json.each do |class_members|
        # Encontra a disciplina e verifica se pertence ao departamento do usuário
        subject = Subject.find_by(code: class_members["code"])
        next unless subject&.department_id == department.id

        school_class = SchoolClass.find_by!(
          subject: subject,
          semester: class_members["semester"]
        )

        # Processa o professor
        teacher_data = class_members["docente"]
        next unless teacher_data["departamento"] == department.name

        teacher = User.find_or_initialize_by(registration_number: teacher_data["usuario"])
        was_new_teacher = teacher.new_record?

        teacher.assign_attributes(
          name: teacher_data["nome"],
          email: teacher_data["email"],
          role: :teacher,
          department: department,
          force_password_change: teacher.new_record?
        )

        if was_new_teacher
          temp_password = SecureRandom.hex(8)
          teacher.password = temp_password
          teacher.password_confirmation = temp_password
          teacher.save!
          @stats[:new_teachers] += 1
          @new_passwords << "Professor #{teacher.name}: #{temp_password}"
        else
          teacher.save!
          @stats[:existing_teachers] += 1
        end

        # Cria ou atualiza matrícula do professor
        enrollment = Enrollment.find_by(school_class: school_class, teacher: teacher)
        unless enrollment
          Enrollment.create!(
            school_class: school_class,
            teacher: teacher,
            role: :teacher
          )
        end

        # Remove matrículas antigas do professor nesta turma
        if enrollment
          removed = school_class.enrollments.where(teacher: teacher).where.not(id: enrollment.id).destroy_all
          @stats[:removed_enrollments] += removed.count
        end

        # Processa os alunos
        current_student_ids = []

        class_members["dicente"].each do |student_data|
          student = User.find_or_initialize_by(registration_number: student_data["matricula"])
          was_new_student = student.new_record?

          student.assign_attributes(
            name: student_data["nome"],
            email: student_data["email"],
            role: :student,
            department: department,
            force_password_change: student.new_record?
          )

          if was_new_student
            temp_password = SecureRandom.hex(8)
            student.password = temp_password
            student.password_confirmation = temp_password
            student.save!
            @stats[:new_students] += 1
            @new_passwords << "Aluno #{student.name} (#{student.registration_number}): #{temp_password}"
          else
            student.save!
            @stats[:existing_students] += 1
          end

          # Cria matrícula do aluno apenas se ainda não existir
          enrollment = Enrollment.find_by(school_class: school_class, user: student)
          unless enrollment
            Enrollment.create!(
              school_class: school_class,
              user: student,
              role: :student
            )
          end

          current_student_ids << student.id
        end

        # Remove matrículas de alunos que não estão mais na turma
        removed = school_class.enrollments.where(teacher_id: nil)
                   .where.not(user_id: current_student_ids)
                   .destroy_all
        @stats[:removed_enrollments] += removed.count
      end

      if @stats.values.sum == 0
        redirect_to new_sigaa_update_path, alert: "Nenhum dado encontrado para o departamento #{department.name}"
      else
        # Prepara mensagem de sucesso com estatísticas
        flash[:notice] = "Dados do SIGAA atualizados com sucesso! " +
                        "Disciplinas atualizadas: #{@stats[:subjects_updated]}, " +
                        "Turmas atualizadas: #{@stats[:classes_updated]}, " +
                        "Novos professores: #{@stats[:new_teachers]}, " +
                        "Professores existentes: #{@stats[:existing_teachers]}, " +
                        "Novos alunos: #{@stats[:new_students]}, " +
                        "Alunos existentes: #{@stats[:existing_students]}, " +
                        "Matrículas removidas: #{@stats[:removed_enrollments]}"

        # Adiciona senhas temporárias se houver
        if @new_passwords.any?
          flash[:passwords] = @new_passwords
        end

        redirect_to authenticated_root_path
      end
    rescue JSON::ParserError
      redirect_to new_sigaa_update_path, alert: "Arquivo JSON inválido"
    rescue StandardError => e
      redirect_to new_sigaa_update_path, alert: "Erro ao atualizar dados: #{e.message}"
    end
  end

  private

  def ensure_admin
    unless current_user.admin?
      redirect_to authenticated_root_path, alert: "Acesso não autorizado"
    end
  end
end
