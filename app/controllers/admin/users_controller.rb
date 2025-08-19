class Admin::UsersController < ApplicationController
  before_action :authenticate_administrator!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(:email)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    # Unblock user by clearing the blocked_at timestamp
    @user.blocked_at = nil if params[:user][:unblock] == '1'

    # Prevent password update if fields are blank
    params_to_update = user_params
    if params_to_update[:password].blank? && params_to_update[:password_confirmation].blank?
      params_to_update.delete(:password)
      params_to_update.delete(:password_confirmation)
    end

    if @user.update(params_to_update)
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def authenticate_administrator!
    redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user&.administrator?
  end
end
