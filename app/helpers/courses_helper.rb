module CoursesHelper
  def course_status_badge_class(course)
    if course.in_progress?
      "bg-success"
    elsif course.not_started?
      "bg-primary"
    else
      "bg-secondary"
    end
  end

  def course_status_icon(course)
    if course.in_progress?
      "fas fa-play-circle me-1"
    elsif course.not_started?
      "fas fa-calendar-alt me-1"
    else
      "fas fa-check-circle me-1"
    end
  end
end

