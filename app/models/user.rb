class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true

  enum :role, { operator: 0, administrator: 1 }

  def active_for_authentication?
    super && !blocked_at?
  end

  def inactive_message
    blocked_at? ? :blocked : super
  end
end
