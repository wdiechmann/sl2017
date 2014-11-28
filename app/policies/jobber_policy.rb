class JobberPolicy < ApplicationPolicy

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError unless user
    @current_user = user
    @record = record
  end

  def create?
    true
  end

  def confirmation?
    true
  end

end
