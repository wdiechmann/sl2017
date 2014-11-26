class UserPolicy < ApplicationPolicy

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    current_user.vip?
  end

  def show?
    current_user.admin? or current_user == record
  end

  def update?
    current_user.admin?
  end

  def destroy?
    return false if current_user == record
    current_user.admin?
  end

end
