class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action : find_user, only: [:create]
  before_action : find_relationship, only: [:destroy]

  def create
    if @user.present?
      current_user.follow @user
    else
      @error = t "follow.follow_fail"
    end
    respond_to :js
  end

  def destroy
    if relationship.present?
      @user = relationship.followed
      current_user.unfollow @user
    else
      @error = t "follow.follow_fail"
    end
    respond_to :js
  end

  private

  def find_user
    @user = User.find_by id: params[:followed_id]
  end

  def find_relationship
    relationship = Relationship.find_by id: params[:id]
  end
end
