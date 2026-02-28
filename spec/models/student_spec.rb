require 'rails_helper'

# Describes the test suite for the Student model.
RSpec.describe Student, type: :model do
  # Groups tests related to model validations.
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  # Groups tests related to model associations.
  describe 'associations' do
    # It tests that a Student has many enrollments.
    # This also checks for the 'dependent: :destroy' option, ensuring
    # that deleting a student record also removes their enrollment records.
    it { should have_many(:enrollments).dependent(:destroy) }

    # It tests the many-to-many relationship: a Student can have many
    # courses by going through the 'enrollments' join table.
    it { should have_many(:courses).through(:enrollments) }
  end

  describe '#active_course_ids' do
    let(:student) { create(:student) }
    let(:active_course) { create(:course, end_date: 1.day.from_now) }
    let(:inactive_course) { create(:course, end_date: 1.day.ago) }

    it 'returns only active course ids' do
      student.courses << active_course
      student.courses << inactive_course
      expect(student.active_course_ids).to eq([active_course.id])
    end
  end

  describe '#active_course_ids=' do
    let(:student) { create(:student) }
    let(:active_course1) { create(:course, end_date: 1.day.from_now) }
    let(:active_course2) { create(:course, end_date: 1.day.from_now) }
    let(:inactive_course) { create(:course, end_date: 1.day.ago) }

    it 'manages active enrollments while preserving inactive ones' do
      student.courses << active_course1
      student.courses << inactive_course

      student.active_course_ids = [active_course2.id]
      student.save
      student.reload

      expect(student.courses).to include(active_course2)
      expect(student.courses).to include(inactive_course)
      expect(student.courses).not_to include(active_course1)
    end

    it 'handles empty input' do
      student.courses << active_course1
      student.active_course_ids = []
      student.save
      expect(student.enrollments.count).to eq(0)
    end
  end
end
