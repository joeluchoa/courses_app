class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      resource.update(blocked_at: Time.current) if resource.persisted?
    end
  end
end
