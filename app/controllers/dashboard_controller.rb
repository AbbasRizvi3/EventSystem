class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

   def index
    authorize :dashboard, :index?
    @registrations = policy_scope(Registration).includes(:user, :event).order(created_at: :desc).page(params[:page]).per(15)
    @waitlist_entries = policy_scope(WaitListEntry).includes(:user, :event).order(:event_id, :position).page(params[:page]).per(15)
  end

    def authorize_admin
    unless current_user.roles.exists?(name: "admin")
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
