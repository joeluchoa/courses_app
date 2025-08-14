class Attendance < ApplicationRecord
  belongs_to :student
  belongs_to :course

  validate :must_be_valid_class_day_and_time, on: :create
  validates :student_id, uniqueness: {
    scope: [:course_id, :attended_on],
    message: "has already been recorded for this course"
  }

  private

  TIME_TOLERANCE = 15.minutes

  def must_be_valid_class_day_and_time
    logger = Logger.new(STDOUT)

    return if course.nil? || attended_on.nil?

    today_schedule = get_course_today_schedule
    logger.info("Today schedule: #{today_schedule}")
    if today_schedule.nil?
      errors.add(:base, "Today is not a scheduled day for this course")
      return
    end

    now = Time.current
    logger.info("Now #{now}")
    valid_start_time = attendance_start_time(today_schedule)
    logger.info("Start date: #{valid_start_time}");
    valid_end_time = attendance_end_time(today_schedule)
    logger.info("End date: #{valid_end_time}");

    unless now.between?(valid_start_time, valid_end_time)
      errors.add(:base, "Today attendance can only be recorded from #{valid_start_time} to #{valid_end_time} for this course")
    end
  end

  def get_course_today_schedule
    day_of_week = attended_on.strftime('%A')
    Logger.new(STDOUT).info("Day of week: #{day_of_week}")

    course.weekly_schedule.each do |schedule|
      return schedule if schedule["day"].downcase == day_of_week.downcase
    end

    nil
  end

  def attendance_start_time(schedule)
    schedule["start_time"].to_datetime - TIME_TOLERANCE
  end

  def attendance_end_time(schedule)
    schedule["end_time"].to_datetime - TIME_TOLERANCE
  end

end
