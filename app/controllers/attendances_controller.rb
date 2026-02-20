class AttendancesController < ApplicationController
  before_action :set_course
  before_action :set_attendance, only: %i[ show edit update destroy ]

  # GET /courses/:course_id/attendances
  def index
    @attendances = @course.attendances.includes(:student).order(attended_on: :desc)
  end

  # GET /courses/:course_id/attendances/1
  def show
  end

  # GET /courses/:course_id/attendances/new
  def new
    @attendance = @course.attendances.new(attended_on: Date.today)
    @students = @course.students.order(:last_name, :first_name)
  end

  # GET /courses/:course_id/attendances/1/edit
  def edit
    @students = @course.students.order(:last_name, :first_name)
  end

  # POST /courses/:course_id/attendances
  def create
    @attendance = @course.attendances.new(attendance_params)
    @attendance.manual_entry = true

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to course_attendances_path(@course), notice: t("flash.actions.create.notice", resource_name: Attendance.model_name.human) }
        format.json { render :show, status: :created, location: [@course, @attendance] }
      else
        @students = @course.students.order(:last_name, :first_name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/:course_id/attendances/1
  def update
    @attendance.manual_entry = true
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to course_attendances_path(@course), notice: t("flash.actions.update.notice", resource_name: Attendance.model_name.human) }
        format.json { render :show, status: :ok, location: [@course, @attendance] }
      else
        @students = @course.students.order(:last_name, :first_name)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/:course_id/attendances/1
  def destroy
    @attendance.destroy!

    respond_to do |format|
      format.html { redirect_to course_attendances_path(@course), status: :see_other, notice: t("flash.actions.destroy.notice", resource_name: Attendance.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_attendance
    @attendance = @course.attendances.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:student_id, :attended_on)
  end
end
