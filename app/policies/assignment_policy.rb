class AssignmentPolicy < ApplicationPolicy

  def initialize(user, record)
    # raise Pundit::NotAuthorizedError unless user
    @current_user = user
    @record = record
  end

  def create?
    true
  end

  def update?
    true
  end

  def accepted_by_jobber?
    true
  end

  def accepted_by_dt?
    true
  end

  def declined_by_jobber?
    true
  end

  def declined_by_dt?
    true
  end


end
