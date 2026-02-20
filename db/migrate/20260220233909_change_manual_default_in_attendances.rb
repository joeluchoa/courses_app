class ChangeManualDefaultInAttendances < ActiveRecord::Migration[8.0]
  def change
    change_column_default :attendances, :manual, from: nil, to: false
  end
end
