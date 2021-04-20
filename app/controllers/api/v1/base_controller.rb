class Api::V1::BaseController < ActionController::API
  include Pundit

  after_action :verify_authorized, only: [:index, :create]

  rescue_from Pundit::NotAuthorizedError,   with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_not_authorized(err)
    render json: {
      error: err
    }, status: :unauthorized
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
