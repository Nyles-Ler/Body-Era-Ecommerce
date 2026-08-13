class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @address = current_user.addresses.order(created_at: :desc).first
  end
end