class WaitListEntryPolicy < ApplicationPolicy
  def create?
    if user.nil?
      false
    else
      user.roles.exists?(name: "attendee") || user.roles.exists?(name: "admin")
    end
  end

  def destroy?
  if user.nil?
    false
  else
  record.user == user || user.roles.exists?(name: "admin")
  end
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
