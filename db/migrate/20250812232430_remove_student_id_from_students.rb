class RemoveStudentIdFromStudents < ActiveRecord::Migration[8.0]
  def change
    remove_column :students, :student_id, :integer
  end
end
