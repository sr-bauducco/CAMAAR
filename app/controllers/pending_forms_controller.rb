class PendingFormsController < ApplicationController
  before_action :authenticate_user!

  def index
    @forms = Form.active
                 .joins(:school_class)
                 .includes(:form_template, school_class: :subject)
                 .where(target_audience: current_user_audience)
                 .where(school_classes: { id: user_classes })
                 .where.not(id: current_user.responses.select(:form_id))
  end

  private

  def current_user_audience
    current_user.teacher? ? :teachers : :students
  end

  def user_classes
    current_user.all_classes.pluck(:id)
  end
end
