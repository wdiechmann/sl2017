class JobPolicy < ApplicationPolicy

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError unless user
    @current_user = user
    @record = record
  end

  def index?
    true
  end

  def create?
    true
  end

end
