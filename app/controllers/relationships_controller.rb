class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    user = User.find(params[:user_id])
    current_user.follow(user.id) #user.idを入れることで、idだけを取得する
    redirect_back(fallback_location: user)
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow!(user)
    redirect_back(fallback_location: user)
  end

end
