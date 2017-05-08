class ExpensesController < ApplicationController

  before_action :authenticate_user!

  def index
    expenses = []
    current_user.expenses.user_expenses.unpaid.group_by(&:resource).each do |user, expense|
      expenses << {user:  user.email, amount: expenses.sum(&:amount) }
    end
    render json: expenses
  end

  def group_expenses
    expenses = []
    current_user.expenses.group_expenses.unpaid.group_by(&:resource).each do |group, expense|
      expenses << {group_title:  group.title, amount: expenses.sum(&:amount) }
    end
    render json: expenses
  end

  def create
    @expenses = []
    if params[:group_id].present?
      create_group_expenses
    elsif params[:emails].present?
      create_user_expenses
    end
    render json: {sucess: true, expense: @expenses}
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

  def settle_up
    pay_user = User.where(id: params[:user_id])
    expenses = current_user.expense.where(resource: pay_user)
    begin
      Expense.transaction do
      expenses.each do |expense|
        expense.pay!
      end
    end
    rescue Exception => e
      return and render json: {sucess: false}
    end
    render json: {sucess: true}
  end

  def pay_amount_user
    pay_user = User.where(id: params[:user_id])
    if current_user.expense.create(amount: params[:amount], description: params[:description], resource: user)
      render json: {sucess: true}
    else
      render json: {sucess: false}
    end
  end

  def update_group_expenses
    @expense = current_user.expenses.find(id: params[:id]) rescue nil
    render json: {sucess: false} and return if @expense.blank?
    @expense.update_attributes(amount: params[:amount], description: params[:description], members: params[:members])
    render json: {sucess: true, expense: @expense}
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
      @group = current_user.groups.includes(:users).find(id: params[:group_id]) rescue nil
      render json: {sucess: false} and return  if @group.blank?
      if params[:has_custom_amount]
        members = params[:members]
      else
        amount_per_user = (params[:amount].to_f / @group.users.count)
        members = {}
        @group.users.each do |user|
          members[user.id] = amount_per_user
        end
      end
      @expenses << current_user.expenses.create(amount: params[:amount], description: params[:description], resource: @group, members: members)
    end
end
