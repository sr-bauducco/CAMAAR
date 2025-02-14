class SigaaUpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :clear_messages, only: [:new]

  def new
    render :new
  end

  def create
    if missing_json_params?
      redirect_to new_sigaa_update_path, alert: "Por favor, selecione os arquivos JSON do SIGAA" and return
    end

    begin
      process_json_data(params[:classes_json], :process_classes)
      process_json_data(params[:members_json], :process_members)
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

  def process_json_data(json_data, method)
    send(method, parse_json(json_data))
  end

  def parse_json(json_param)
    JSON.parse(json_param.read)
  end

  def process_classes(classes_json)
    classes_json.each { |class_data| process_class(class_data) }
  end

  def process_class(class_data)
    return unless valid_department?(class_data["department"])

    subject = find_or_create_subject(class_data)
    update_subject_and_class(class_data, subject)
  end

  def process_members(members_json)
    members_json.each { |class_members| process_member_data(class_members) }
  end

  def process_member_data(class_members)
    subject = find_subject(class_members)
    return unless valid_department?(subject&.department_id)

    school_class = find_school_class(subject, class_members)
    process_teacher_and_students(class_members, school_class)
  end

  def valid_department?(department_id)
    department_id == current_user.department.id
  end

  def find_or_create_subject(class_data)
    Subject.find_or_create_by!(code: class_data["code"]) do |s|
      s.name = class_data["name"]
      s.department = current_user.department
    end
  end

  def update_subject_and_class(class_data, subject)
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

  def process_teacher_and_students(class_members, school_class)
    process_teacher(class_members["docente"], school_class)
    process_students(class_members["dicente"], school_class)
  end

  def process_teacher(teacher_data, school_class)
    return unless valid_department?(teacher_data["departamento"])

    teacher = find_or_initialize_user(teacher_data, :teacher)
    handle_user_password(teacher)
    create_or_update_enrollment(school_class, teacher)
  end

  def process_students(student_data, school_class)
    current_student_ids = student_data.map do |student_data|
      student = find_or_initialize_user(student_data, :student)
      handle_user_password(student)
      create_or_update_enrollment(school_class, student)
      student.id
    end

    remove_old_enrollments(school_class, current_student_ids)
  end

  def find_or_initialize_user(user_data, role)
    User.find_or_initialize_by(registration_number: user_data["usuario"] || user_data["matricula"]).tap do |user|
      user.assign_attributes(
        name: user_data["nome"],
        email: user_data["email"],
        role: role,
        department: current_user.department
      )
    end
  end

  def handle_user_password(user)
    return if user.persisted?

    temp_password = generate_temp_password
    user.password = user.password_confirmation = temp_password
    user.save!
    @new_passwords << "#{user.role.capitalize} #{user.name}: #{temp_password}"
    increment_stat("#{user.role}s_updated".to_sym)
  end

  def generate_temp_password
    SecureRandom.hex(8)
  end

  def create_or_update_enrollment(school_class, user)
    Enrollment.find_or_create_by!(school_class: school_class, user: user, role: user.role)
  end

  def remove_old_enrollments(school_class, current_ids)
    removed = school_class.enrollments.where.not(user_id: current_ids).destroy_all
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
