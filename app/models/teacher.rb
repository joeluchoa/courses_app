class Teacher < ApplicationRecord
  has_many :courses, dependent: :restrict_with_error

  validates :name, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
