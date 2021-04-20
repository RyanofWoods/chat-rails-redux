class ChannelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_logged_in?
  end

  def index?
    user_logged_in?
  end

  def update?
    user_is_authenticated_and_authorized?
  end

  def destroy?
    user_is_authenticated_and_authorized?
  end

  private

  def user_is_authenticated_and_authorized?
    return true if user_logged_in? && user_is_authorized?

    raise Pundit::NotAuthorizedError, 'Request declined. You are not an admin or owner of the channel.'
  end

  def user_is_authorized?
    @user.admin_authority? || (@record.owner == @user)
  end
end
