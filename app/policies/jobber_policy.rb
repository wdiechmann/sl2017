class JobberPolicy < ApplicationPolicy

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError unless user
    @current_user = user
    @record = record
  end

  def index?
    current_user.vip?
  end

  def show?
    current_user.vip?
  end

  def create?
    true
  end

  def update?
    current_user.vip?
  end

  def destroy?
    current_user.vip?
  end

  def confirmation?
    true
  end

end
