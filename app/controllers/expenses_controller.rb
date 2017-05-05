class ExpensesController < ApplicationController

  before_filter :authenticate_user!

  def index
  end

  def create
    if params[:group_id].present?
      create_group_expenses
    elsif params[:emails].present?
      create_user_expenses
    end
  end

  def show
  end

  def update
  end

  def destory
  end


  private
    def create_user_expenses
      if params[:emails].size > 1
        amount_per_user = (params[:amount].to_f / params[:emails].size)
        params[:emails].each do |email|
          user = User.where(email: email.first).take
          current_user.expenses.create(amount: amount_per_user, description: params[:description], resource: user)
        end
      else
        @user = User.where(email: params[:emails].first).take
        current_user.expenses.create(amount: params[:amount], description: params[:description], resource: @user)
      end
    end

    def create_group_expenses
    end
end
