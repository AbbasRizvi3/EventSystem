class RegistrationPolicy < ApplicationPolicy
  def create?
    user.roles.exists?(name: "attendee") || user.roles.exists?(name: "admin")
  end

  def destroy?
    record.user == user || user.roles.exists?(name: "admin")
  end

  def index?
  user.roles.exists?(name: "admin")
  end


class Scope < ApplicationPolicy::Scope
  def resolve
    if user.roles.exists?(name: "admin")
      scope.all
    else
      scope.where(user: user)
    end
  end
end
end
