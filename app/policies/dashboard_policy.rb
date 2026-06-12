class DashboardPolicy < ApplicationPolicy
  def index?
    user.roles.exists?(name: "admin")
  end
end
