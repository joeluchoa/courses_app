class AddUniqueIndexToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_index :enrollments, [:student_id, :course_id], unique: true
  end
end
