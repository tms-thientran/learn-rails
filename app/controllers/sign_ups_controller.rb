class SignUpsController < ApplicationController
  unauthenticated_access_only

  def show
    @user = User.new
    flash.discard(:notice)
  end

  def create
    sign_up_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = User.new(sign_up_params)

    if @user.save
      start_new_sesion_for(@user)

      redirect_to root_path
    else
      render :show, status: :unprocessable_entity
    end
  end
end
