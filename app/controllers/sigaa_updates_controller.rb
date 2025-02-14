class SigaaUpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :clear_messages, only: [:new]

  def new
    render :new
  end

  def create
    if missing_json_params?
      redirect_to new_sigaa_update_path, alert: "Por favor, selecione os arquivos JSON do SIGAA"
      return
    end

    begin
      process_classes(params[:classes_json])
      process_members(params[:members_json])
      handle_flash_message
    rescue JSON::ParserError
      redirect_to new_sigaa_update_path, alert: "Arquivo JSON inválido"
    rescue StandardError => e
      redirect_to new_sigaa_update_path, alert: "Erro ao atualizar dados: #{e.message}"
    end
  end

  private

  def missing_json_params?
    params[:classes_json].nil? || params[:members_json].nil?
  end

  def process_classes(classes_json)
    department = current_user.department
    classes_json = parse_json(classes_json)

    classes_json.each do |class_data|
      next unless valid_department?(class_data["department"], department)

      subject = find_or_create_subject(class_data)
      update_class(class_data, subject)
    end
  end

  def process_members(members_json)
    department = current_user.department
    members_json = parse_json(members_json)

    members_json.each do |class_members|
      subject = find_subject(class_members)
      next unless valid_department?(subject&.department_id, department.id)

      school_class = find_school_class(subject, class_members)
      process_teacher(class_members, department, school_class)
      process_students(class_members, department, school_class)
    end
  end

  def parse_json(json_param)
    JSON.parse(json_param.read)
  end

  def valid_department?(department_name, department)
    department_name == department.name
  end

  def find_or_create_subject(class_data)
    Subject.find_or_create_by!(code: class_data["code"]) do |s|
      s.name = class_data["name"]
      s.department = current_user.department
    end
  end

  def update_class(class_data, subject)
    if subject.name != class_data["name"]
      subject.update!(name: class_data["name"])
      increment_stat(:subjects_updated)
    end

    SchoolClass.find_or_create_by!(subject: subject, semester: class_data["class"]["semester"])
    increment_stat(:classes_updated)
  end

  def increment_stat(stat)
    @stats[stat] ||= 0
    @stats[stat] += 1
  end

  def find_subject(class_members)
    Subject.find_by(code: class_members["code"])
  end

  def find_school_class(subject, class_members)
    SchoolClass.find_by!(subject: subject, semester: class_members["semester"])
  end

  def process_teacher(class_members, department, school_class)
    teacher_data = class_members["docente"]
    return unless valid_department?(teacher_data["departamento"], department)

    teacher = find_or_initialize_teacher(teacher_data, department)
    handle_teacher_password(teacher)

    create_or_update_enrollment(school_class, teacher)
  end

  def find_or_initialize_teacher(teacher_data, department)
    User.find_or_initialize_by(registration_number: teacher_data["usuario"]).tap do |teacher|
      teacher.assign_attributes(
        name: teacher_data["nome"],
        email: teacher_data["email"],
        role: :teacher,
        department: department
      )
    end
  end

  def handle_teacher_password(teacher)
    if teacher.new_record?
      temp_password = generate_temp_password
      teacher.password = temp_password
      teacher.password_confirmation = temp_password
      teacher.save!
      @new_passwords << "Professor #{teacher.name}: #{temp_password}"
      increment_stat(:new_teachers)
    else
      teacher.save!
      increment_stat(:existing_teachers)
    end
  end

  def generate_temp_password
    SecureRandom.hex(8)
  end

  def create_or_update_enrollment(school_class, teacher)
    enrollment = Enrollment.find_by(school_class: school_class, teacher: teacher)
    unless enrollment
      Enrollment.create!(school_class: school_class, teacher: teacher, role: :teacher)
    end

    remove_old_enrollments(school_class, teacher, enrollment)
  end

  def remove_old_enrollments(school_class, teacher, enrollment)
    return unless enrollment

    removed = school_class.enrollments.where(teacher: teacher).where.not(id: enrollment.id).destroy_all
    @stats[:removed_enrollments] += removed.count
  end

  def process_students(class_members, department, school_class)
    current_student_ids = []

    class_members["dicente"].each do |student_data|
      student = find_or_initialize_student(student_data, department)
      handle_student_password(student)

      create_or_update_student_enrollment(school_class, student)
      current_student_ids << student.id
    end

    remove_old_student_enrollments(school_class, current_student_ids)
  end

  def find_or_initialize_student(student_data, department)
    User.find_or_initialize_by(registration_number: student_data["matricula"]).tap do |student|
      student.assign_attributes(
        name: student_data["nome"],
        email: student_data["email"],
        role: :student,
        department: department
      )
    end
  end

  def handle_student_password(student)
    if student.new_record?
      temp_password = generate_temp_password
      student.password = temp_password
      student.password_confirmation = temp_password
      student.save!
      @new_passwords << "Aluno #{student.name} (#{student.registration_number}): #{temp_password}"
      increment_stat(:new_students)
    else
      student.save!
      increment_stat(:existing_students)
    end
  end

  def create_or_update_student_enrollment(school_class, student)
    enrollment = Enrollment.find_by(school_class: school_class, user: student)
    unless enrollment
      Enrollment.create!(school_class: school_class, user: student, role: :student)
    end
  end

  def remove_old_student_enrollments(school_class, current_student_ids)
    removed = school_class.enrollments.where(teacher_id: nil)
                          .where.not(user_id: current_student_ids)
                          .destroy_all
    @stats[:removed_enrollments] += removed.count
  end

  def handle_flash_message
    if @stats.values.sum == 0
      redirect_to new_sigaa_update_path, alert: "Nenhum dado encontrado para o departamento #{current_user.department.name}"
    else
      flash[:notice] = generate_flash_notice
      flash[:passwords] = @new_passwords if @new_passwords.any?
      redirect_to authenticated_root_path
    end
  end

  def generate_flash_notice
    "Dados do SIGAA atualizados com sucesso! " +
      "Disciplinas atualizadas: #{@stats[:subjects_updated]}, " +
      "Turmas atualizadas: #{@stats[:classes_updated]}, " +
      "Novos professores: #{@stats[:new_teachers]}, " +
      "Professores existentes: #{@stats[:existing_teachers]}, " +
      "Novos alunos: #{@stats[:new_students]}, " +
      "Alunos existentes: #{@stats[:existing_students]}, " +
      "Matrículas removidas: #{@stats[:removed_enrollments]}"
  end

  def clear_messages
    flash.clear
  end

  def ensure_admin
    redirect_to authenticated_root_path, alert: "Acesso não autorizado" unless current_user.admin?
  end
end
