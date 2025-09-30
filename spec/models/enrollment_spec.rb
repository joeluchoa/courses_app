require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  describe 'associations' do
    it { should belong_to(:course) }
    it { should belong_to(:student) }
  end

  # --- Start of Corrected Block ---
  describe 'database constraints' do
    it 'validates uniqueness of a student in the scope of a course' do
      # 1. Create a valid Teacher, because a Course needs one.
      #    (Assuming a Teacher model exists and requires a name)
      teacher = Teacher.create!(name: 'Professor Oak')

      # 2. Create a valid Student.
      student = Student.create!(first_name: 'John', last_name: 'Doe')

      # 3. Create a valid Course, providing all required attributes.
      course = Course.create!(
        name: 'Ruby on Rails 101',
        teacher: teacher,
        address: '123 Test Lane'
      )

      # 4. Create the first, valid enrollment. This should succeed.
      Enrollment.create!(student: student, course: course)

      # 5. Attempt to create the exact same enrollment again.
      #    This should fail at the database level because of the unique index.
      duplicate_enrollment = Enrollment.new(student: student, course: course)
      expect {
        duplicate_enrollment.save(validate: false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
  # --- End of Corrected Block ---
end
