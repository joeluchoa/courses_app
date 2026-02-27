module CoursesHelper
  def course_status_badge_class(course)
    if course.in_progress?
      "bg-success"
    elsif course.not_started?
      "bg-warning text-dark"
    elsif course.finished?
      "bg-danger"
    else
      "bg-secondary"
    end
  end

  def course_status_icon(course)
    if course.in_progress?
      "bi bi-check-circle me-1"
    elsif course.not_started?
      "bi bi-hourglass-split me-1"
    elsif course.finished?
      "bi bi-x-circle me-1"
    else
      "bi bi-question-circle me-1"
    end
  end
end

