require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:courses).dependent(:restrict_with_error) }
  end
end
