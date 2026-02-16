require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let(:teacher) { create(:teacher) }
  let(:course) { create(:course, teacher: teacher) }
  let(:student) { create(:student) }

  before do
    login_as(create(:user, :admin), scope: :user)
  end

  describe "GET /courses" do
    it "returns http success" do
      get courses_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /courses" do
    let(:valid_attributes) do
      {
        name: "New Course",
        description: "Description",
        address: "Test Address",
        start_date: Date.today,
        end_date: Date.today + 30.days,
        teacher_id: teacher.id,
        weekly_schedule_attributes: {
          "0" => { day: "monday", start_time: "09:00", end_time: "10:00", enabled: "1" }
        }
      }
    end

    it "creates a new Course" do
      expect {
        post courses_path, params: { course: valid_attributes }
      }.to change(Course, :count).by(1)
    end

    it "redirects to the created course" do
      post courses_path, params: { course: valid_attributes }
      expect(response).to redirect_to(course_path(Course.last))
    end
  end

  describe "GET /courses/:id/scan_attendance" do
    it "returns http success" do
      get scan_attendance_course_path(course, locale: :en)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /courses/:id/register_attendance" do
    before do
      course.students << student
    end

    it "registers attendance for enrolled student" do
      expect {
        post register_attendance_course_path(course, locale: :en), params: { student_id: student.id }
      }.to change(Attendance, :count).by(1)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('success')
    end

    it "returns error for unenrolled student" do
      unenrolled_student = create(:student)

      expect {
        post register_attendance_course_path(course, locale: :en), params: { student_id: unenrolled_student.id }
      }.not_to change(Attendance, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('error')
      expect(json_response['message']).to eq('Student not enrolled in this course.')
    end
  end
end
