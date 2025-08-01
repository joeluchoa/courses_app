class AddDetailsToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :date_of_birth, :date
    add_column :students, :phone, :string
    add_column :students, :tax_code, :string
    add_column :students, :address, :text
  end
end
