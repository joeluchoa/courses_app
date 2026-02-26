require "test_helper"

class StudentTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  test "should be valid with valid attributes" do
    student = build(:student)
    assert student.valid?
  end

  test "should be invalid without first_name" do
    student = build(:student, first_name: nil)
    assert_not student.valid?
    assert student.errors[:first_name].present?
  end

  test "should be invalid without last_name" do
    student = build(:student, last_name: nil)
    assert_not student.valid?
    assert student.errors[:last_name].present?
  end


  test "full_name returns first and last name" do
    student = build(:student, first_name: "John", last_name: "Doe")
    assert_equal "John Doe", student.full_name
  end

end
