class UserPolicy < ApplicationPolicy
    def index?
    user.roles.exists?(name: "admin")
  end

  def show?
    user.roles.exists?(name: "admin") || record == user
  end

  def destroy?
    user.roles.exists?(name: "admin") && record != user
  end

  def new?
  create?
  end

  def create?
  user.roles.exists?(name: "admin")
  end

  def update_roles?
  user.roles.exists?(name: "admin")
  end

  class Scope < ApplicationPolicy::Scope
  def resolve
    if user.roles.exists?(name: "admin")
      scope.all
    else
      scope.where(id: user.id)
    end
  end
  end
end
