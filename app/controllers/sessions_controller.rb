class SessionsController < ApplicationController
  unauthenticated_access_only only: %i[new create]

  def new
    @user = User.new
  end

  def create
    param = params.require(:user).permit(:email, :password)
    user_logined = User.authenticate_by(param)

    if user_logined
      start_new_sesion_for(user_logined)
      redirect_to after_authentication_url, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session

    redirect_to new_session_path, status: :see_other
  end
end
