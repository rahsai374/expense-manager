class ExpensesController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def create
    @expenses = []
    if params[:group_id].present?
      create_group_expenses
    elsif params[:emails].present?
      create_user_expenses
    end
    render json: @expenses
  end

  def show
    @expense = current_user.expenses.where(id: params[:id]).take
    render json: @expense
  end

  def update
    @expense = current_user.expenses.where(id: params[:id]).take
    @expense.update_attributes(amount: params[:amount], description: params[:description])
    render json: @expense
  end

  def destroy
    @expense = current_user.expenses.where(id: params[:id]).take
    @expense.destroy
    render json: {sucess: true}
  end


  private
    def create_user_expenses
      if params[:emails].size > 1
        amount_per_user = (params[:amount].to_f / params[:emails].size)
        params[:emails].each do |email|
          user = User.where(email: email).take
          user = User.invite!(email: email) unless user.present?
          @expenses << current_user.expenses.create(amount: amount_per_user, description: params[:description], resource: user)
        end
      else
        user = User.where(email: params[:emails].first).take
        user = User.invite!(email: params[:emails].first) unless user.present?
        @expenses << current_user.expenses.create(amount: params[:amount], description: params[:description], resource: user)
      end
    end

    def create_group_expenses
    end
end
