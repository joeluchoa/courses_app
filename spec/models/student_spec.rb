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
end
