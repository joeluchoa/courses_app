class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true

  enum :role, { operator: 0, administrator: 1 }

  scope :search_by_name, ->(query) {
    if query.present?
      where("name ILIKE :q OR email ILIKE :q", q: "%#{query}%")
    end
  }

  scope :active, -> { where(blocked_at: nil) }
  scope :blocked, -> { where.not(blocked_at: nil) }

  def active_for_authentication?
    super && !blocked_at?
  end

  def inactive_message
    blocked_at? ? :blocked : super
  end

  def blocked?
    blocked_at?
  end
end
