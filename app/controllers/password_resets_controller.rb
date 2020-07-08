class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, only: %w(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] =  t "password_resets.sended_email"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.unsended_email"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      flash[:danger] = t ".update_password_reset"
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t ".update_password_success"
      redirect_to @user
    else
      flash[:danger] = t ".update_password_fail"
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t".not_found_user"
    redirect_to root_url
  end

  def valid_user
    return if (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
