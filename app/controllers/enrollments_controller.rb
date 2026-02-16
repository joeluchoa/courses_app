class EnrollmentsController < ApplicationController
  before_action :set_course

  # POST /courses/:course_id/enrollments
  def create
    @enrollment = @course.enrollments.build(enrollment_params)
    if @enrollment.save
      redirect_to @course, notice: t("enrollments.create.success")
    else
      # Re-render the course show page with an error
      redirect_to @course, alert: t("enrollments.create.failure", error: @enrollment.errors.full_messages.to_sentence)
    end
  end

  # DELETE /courses/:course_id/enrollments/:id
  def destroy
    @enrollment = @course.enrollments.find(params[:id])
    @enrollment.destroy
    redirect_to @course, notice: t("enrollments.destroy.success")
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:student_id)
  end
end
