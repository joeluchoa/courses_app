require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'validations' do
    let(:course) { create(:course) }
    let(:student) { create(:student) }
    let(:attendance) { build(:attendance, course: course, student: student) }

    it 'is valid with valid attributes' do
      expect(attendance).to be_valid
    end

    it 'validates uniqueness of student_id scoped to course_id and attended_on' do
      create(:attendance, course: course, student: student, attended_on: Date.today)
      duplicate_attendance = build(:attendance, course: course, student: student, attended_on: Date.today)
      expect(duplicate_attendance).not_to be_valid
      expect(duplicate_attendance.errors[:student_id]).to include(I18n.t('activerecord.errors.models.attendance.attributes.student_id.already_registered'))
    end

    it 'validates course is in progress' do
      course.update(start_date: 2.days.ago, end_date: 1.day.ago)
      attendance.attended_on = Date.today
      expect(attendance).not_to be_valid
      expect(attendance.errors[:base]).to include(I18n.t('activerecord.errors.models.attendance.attributes.base.course_not_in_progress'))
    end

    describe '#must_be_valid_class_day_and_time' do
      it 'is valid if today is a scheduled day' do
        # Course factory creates schedule for all days
        attendance.attended_on = Date.today
        expect(attendance).to be_valid
      end

      it 'is invalid if today is not a scheduled day' do
        course.weekly_schedule = [] # Clear schedule
        attendance.attended_on = Date.today
        expect(attendance).not_to be_valid
        expect(attendance.errors[:base]).to include(I18n.t('activerecord.errors.models.attendance.attributes.base.not_scheduled_today'))
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:student) }
    it { should belong_to(:course) }
  end
end
