require 'rails_helper'

RSpec.describe Course, type: :model do
  # First, create valid instances of any associated models.
  # We assume you have a Teacher model that requires a name.
  let(:teacher) { Teacher.create(name: 'Dr. Smith') }

  # Now, create the subject of our tests.
  # This subject is a valid Course object that satisfies all validations.
  # This allows each validation test to run in isolation.
  subject {
    described_class.new(
      name: 'Introduction to Rails',
      teacher: teacher,
      address: '123 University Ave'
    )
  }

  describe 'validations' do
    # This test will now pass because the subject provides a valid
    # teacher and address, isolating the test to only the :name attribute.
    it { should validate_presence_of(:name) }

    # We should also add tests for the other validations we discovered!
    it { should validate_presence_of(:address) }
  end

  describe 'associations' do
    # This test verifies the belongs_to relationship. By default in Rails,
    # a belongs_to association also implies a presence validation.
    it { should belong_to(:teacher) }

    # The original association tests are still valid.
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:students).through(:enrollments) }
  end
end
