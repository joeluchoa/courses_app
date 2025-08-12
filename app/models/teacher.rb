class Teacher < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
