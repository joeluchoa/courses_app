class Student < ApplicationRecord
  has_one_attached :photo
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :attendances, dependent: :destroy

  accepts_nested_attributes_for :enrollments, reject_if: :all_blank, allow_destroy: true

  validates :first_name, presence: true
  validates :last_name, presence: true


  def full_name
    "#{first_name} #{last_name}"
  end
end
