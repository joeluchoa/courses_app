class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :set_teachers, only: [ :new, :create, :edit, :update ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    # @course is already set by your set_course before_action

    # Get students who are already in the course
    @enrolled_students = @course.students.order(:last_name, :first_name)

    # Get students who are NOT in the course to populate the enrollment dropdown
    @potential_students = Student.where.not(id: @course.student_ids).order(:last_name, :first_name)

    # Initialize an empty enrollment object for the form helper
    @enrollment = Enrollment.new
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: t("flash.actions.create.notice", resource_name: Course.model_name.human) }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: t("flash.actions.update.notice", resource_name: Course.model_name.human) }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: t("flash.actions.destroy.notice", resource_name: Course.model_name.human) }
      format.json { head :no_content }
    end
  end

  def scan_attendance
    @course = Course.find(params[:id])
  end

  def register_attendance
    @course = Course.find(params[:id])
    student = Student.find(params[:student_id])

    # Check if student is enrolled
    unless @course.students.include?(student)
      render json: { status: "error", message: t("scanner.flash.student_not_enrolled") }, status: :unprocessable_entity
      return
    end

    # Create the attendance record for today
    attendance = @course.attendances.new(student: student, attended_on: Date.today)

    if attendance.save
      render json: { status: "success", message: t("scanner.flash.student_marked_present", student: student.first_name) }
    else
      render json: { status: "error", message: attendance.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def attendance_table
    @course = Course.find(params[:id])
    @students = @course.students.order(:last_name, :first_name)

    # 1. Determine the columns: Calculate all the specific dates the class runs.
    @class_days = []
    wdays = selected_days(@course)
    logger.info "Cource weekdays: #{wdays}"
    if @course.start_date.present? && @course.end_date.present?
      (@course.start_date..@course.end_date).each do |date|
        day_name = date.strftime("%A").downcase
        if wdays.include?(day_name)
          @class_days << date
        end
      end
    end

    # 2. Fetch all attendance data for this course efficiently.
    # We build a Hash mapping [student_id, date_string] to the actual attendance object.
    @attendance_map = @course.attendances.each_with_object({}) do |attendance, map|
      date_key = attendance.attended_on.to_date.to_s
      map[[ attendance.student_id, date_key ]] = attendance
    end

    @attendance_counts = @course.attendances.group(:student_id).count

    respond_to do |format|
      format.html do
        if params[:download] == "true"
          render layout: "pdf"
        end
      end
    end
  end


  private

  def selected_days(course)
    wdays = []
    course.weekly_schedule.each do |schedule|
      wdays << schedule["day"].downcase
    end
    wdays
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params.expect(:id))
  end

  def set_teachers
    @teachers = Teacher.all.order(:name)
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(
      :name,
      :description,
      :start_date,
      :end_date,
      :address,
      :teacher_id,
      weekly_schedule_attributes: [ :day, :start_time, :end_time, :_destroy, :enabled ]
    )
  end
end
