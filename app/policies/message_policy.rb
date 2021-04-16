class MessagePolicy < ApplicationPolicy
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

  private

  def user_logged_in?
    !@user.nil?
  end
end
