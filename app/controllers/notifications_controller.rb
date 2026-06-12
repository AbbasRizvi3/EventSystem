class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(15)
  end
end
