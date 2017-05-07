class GroupsController < ApplicationController

  before_action :authenticate_user!
  def index
    @groups = current_user.groups
     render json: @groups
  end

  def create
    @group = Group.create(title: params[:title])
    add_user_to_group(@group)
    render json: @group
  end

  def show
    
  end

  def update
  end

  def destory
  end

  private
    def add_user_to_group(group)
      params[:emails].each do |email|
        user = User.where(email: email).take
        user = User.invite!(email: email) unless user.present?
        group.group_user.create(user_id: user.id)
      end
    end
end
