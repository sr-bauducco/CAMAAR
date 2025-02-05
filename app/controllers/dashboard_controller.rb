class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @pending_forms = current_user.student? ? pending_student_forms : pending_admin_forms
  end

  private

  def pending_student_forms
    Form.joins(school_class: :enrollments)
        .where(enrollments: { user: current_user })
        .where(status: :active)
        .where.not(id: current_user.responses.select(:form_id))
  end

  def pending_admin_forms
    if current_user.admin?
      Form.joins(school_class: { subject: :department })
          .where(departments: { id: current_user.department_id })
    else
      Form.none
    end
  end
end
