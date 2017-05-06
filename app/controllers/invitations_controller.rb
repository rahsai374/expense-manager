class InvitationsController < Devise::InvitationsController
  include InvitableMethods
  before_action :authenticate_user!, only: :create
  before_action :resource_from_invitation_token, only: [:edit, :update]

  def create
    User.invite!(invite_params, current_user)
    render json: { success: ['User created.'] }, status: :created
  end

  def edit
    client_api_url = 'localhost:3000'
    redirect_to "#{client_api_url}?invitation_token=#{params[:invitation_token]}"
  end

  def update
    user = User.accept_invitation!(accept_invitation_params)
    if @user.errors.empty?
      render json: { success: ['User updated.'] }, status: :accepted
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def invite_params
    params.permit(user: [:email, :invitation_token, :provider, :skip_invitation])
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
