class ApplicationPolicy
  attr_reader :current_user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError unless user
    @current_user = user
    @record = record
  end

  def index?
    current_user.has_role? :user
  end

  # the scope - the one which this user is allowed to see 
  # does that have this record?
  def show?
    current_user.has_role? :user
    # scope.where(:id => record.id).exists?
  end

  def create?
    current_user.has_role? :user
  end

  def new?
    create?
  end

  def update?
    current_user.has_role? :user
  end

  def edit?
    update?
  end

  def destroy?
    current_user.has_role? :user
  end

  def scope
    Pundit.policy_scope!(current_user, record.class)
  end

  class Scope
    attr_reader :current_user, :scope

    def initialize(user, scope)
      @current_user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
