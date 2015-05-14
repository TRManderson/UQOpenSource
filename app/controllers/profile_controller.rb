class ProfileController < ApplicationController
  def show
    @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound => e
      flash[:error]="The user you tried to access doesn't exist"
      if request.referrer
        redirect_to request.referrer
      else
        redirect_to root_path
      end
  end
end
