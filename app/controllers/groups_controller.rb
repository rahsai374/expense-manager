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
    @group = current_user.groups.where(id: params[:id]).take
    if @group.present?
      render json: { sucess: true, group: @group, members: @group.users, expenses: @group.expenses }
    else
      render json: {sucess: false}
    end

  end

  def update
    @group = current_user.groups.where(id: params[:id]).take
    if @group.present? && @group.update_attributes(title: params[:title])
      render json: { sucess: true } and return
    end
    render json: {sucess: false}
  end

  def destroy
    @group = current_user.groups.where(id: params[:id]).take
    if @group.present? && @group.destroy
      render json: { sucess: true } and return
    end
    render json: {sucess: false}
  end

  def add_member_to_group
    @group = current_user.groups.where(id: params[:id]).take
    if @group.present?
      user = User.where(email: params[:email]).take
      user = User.invite!(email: params[:email]) unless user.present?
      render json: { sucess: true } and return
    end
    render json: {sucess: false}
  end

  private
    def add_user_to_group(group)
      group.group_users.create(user_id: current_user.id)
      params[:emails].each do |email|
        user = User.where(email: email).take
        user = User.invite!(email: email) unless user.present?
        group.group_users.create(user_id: user.id)
      end
    end
end
