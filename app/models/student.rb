class Student < ApplicationRecord
  has_one_attached :photo
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :attendances, dependent: :destroy

  accepts_nested_attributes_for :enrollments, reject_if: :all_blank, allow_destroy: true

  validates :first_name, presence: true
  validates :last_name, presence: true


  scope :active, -> { where("EXISTS (SELECT 1 FROM enrollments JOIN courses ON enrollments.course_id = courses.id WHERE enrollments.student_id = students.id AND courses.end_date >= ?)", Time.zone.now) }
  scope :inactive, -> { where.not(id: active.select(:id)) }
  scope :search_by_name, ->(query) {
    if query.present?
      where("first_name ILIKE :q OR last_name ILIKE :q", q: "%#{query}%")
    end
  }

  def active?
    courses.active.exists?
  end

  def active_course_ids
    courses.active.pluck(:id)
  end

  def active_course_ids=(ids)
    @active_course_ids_to_set = Array(ids).reject(&:blank?).map(&:to_i)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  after_save :update_active_enrollments

  private

  def update_active_enrollments
    return if @active_course_ids_to_set.nil?

    ids = @active_course_ids_to_set
    current_active_ids = active_course_ids
    
    # Remove enrollments for active courses not in the new list
    (current_active_ids - ids).each do |id|
      enrollments.find_by(course_id: id)&.destroy
    end

    # Add enrollments for active courses in the new list not already present
    (ids - current_active_ids).each do |id|
      enrollments.find_or_create_by(course_id: id)
    end
    
    @active_course_ids_to_set = nil
  end

end
