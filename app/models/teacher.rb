class Teacher < ApplicationRecord
  has_many :courses, dependent: :restrict_with_error

  validates :name, presence: true
  #validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
