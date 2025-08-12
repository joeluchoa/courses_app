module StudentsHelper
  def course_row_color(course)
    if course.in_progress?
      "table-success"
    elsif course.not_started?
      "table-warning"
    elsif course.finished?
      "table-danger"
    else
      ""
    end
  end
end
