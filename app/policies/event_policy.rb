class EventPolicy < ApplicationPolicy
  def index?
    true
  end

 def show?
  if user.nil?
    false
  elsif user.roles.exists?(name: "admin") || user.roles.exists?(name: "attendee")
    true
  elsif user.roles.exists?(name: "organizer")
    record.user == user || record.registrations.exists?(user: user)
  else
    false
  end
end

  def new?
    create?
  end

  def edit?
    update?
  end

  def create?
    if user.nil?
      false
    else
      user.roles.exists?(name: "admin") || user.roles.exists?(name: "organizer")
    end
  end

  def update?
  if user.nil?
    false
  else
  user.roles.exists?(name: "admin") || (record.user == user && user.roles.exists?(name: "organizer"))
  end
  end

def destroy?
  if user.nil?
    false
  else
    user.roles.exists?(name: "admin")
  end
end

def cancel?
  if user.nil?
    false
  else
    user.roles.exists?(name: "admin") || (record.user == user && user.roles.exists?(name: "organizer"))
  end
end

class Scope < ApplicationPolicy::Scope
  def resolve
    if user.roles.exists?(name: "admin") || user.roles.exists?(name: "attendee")
      scope.all
    else
      scope.where(user: user).or(scope.where(id: Registration.where(user: user).select(:event_id)))
    end
  end
end
end
