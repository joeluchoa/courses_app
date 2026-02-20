class AttendancesController < ApplicationController
  before_action :set_course, only: %i[ new edit create update destroy ]
  before_action :set_attendance, only: %i[ show edit update destroy ]

  # GET /attendances OR /courses/:course_id/attendances
  def index
    if params[:course_id]
      @course = Course.find(params[:course_id])
      @attendances = @course.attendances.includes(:student)
    else
      @attendances = Attendance.includes(:student, :course)
    end

    # Apply Filters
    @attendances = @attendances.where(course_id: params[:filter_course_id]) if params[:filter_course_id].present?
    @attendances = @attendances.where(student_id: params[:filter_student_id]) if params[:filter_student_id].present?
    
    if params[:filter_date].present?
      begin
        filter_date = Date.parse(params[:filter_date])
        @attendances = @attendances.where(attended_on: filter_date.all_day)
      rescue Date::Error
        # Ignore invalid dates
      end
    end

    @attendances = @attendances.order(attended_on: :desc)
    
    # Data for filters
    @courses = Course.all.order(:name)
    @students = Student.all.order(:last_name, :first_name)
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
    @attendance.manual = true

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
    # Note: We don't force manual=true on update because it might have been scanned before.
    # But usually, it stays manual if it was manual.
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
    @course = @attendance.course # Ensure @course is set for direct top-level destroys if any
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
    # If course_id is present (nested), we find through course for safety.
    # Otherwise, it's global access.
    if params[:course_id]
      set_course
      @attendance = @course.attendances.find(params[:id])
    else
      @attendance = Attendance.find(params[:id])
      @course = @attendance.course # Set for views that might expect it
    end
  end

  def attendance_params
    params.require(:attendance).permit(:student_id, :attended_on)
  end
end
