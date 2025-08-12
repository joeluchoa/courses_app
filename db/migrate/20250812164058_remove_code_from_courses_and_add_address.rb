class RemoveCodeFromCoursesAndAddAddress < ActiveRecord::Migration[8.0]
  def change
    remove_column :courses, :code, :string
    add_column :courses, :address, :string
  end
end
