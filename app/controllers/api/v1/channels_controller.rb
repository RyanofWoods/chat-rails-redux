require 'pry-byebug'

class Api::V1::ChannelsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  after_action :verify_authorized, only: [ :index ]
  after_action :verify_policy_scoped, only: [ :index ]

  def index
    authorize Channel.new
    @channels = policy_scope(Channel)
  end
end
