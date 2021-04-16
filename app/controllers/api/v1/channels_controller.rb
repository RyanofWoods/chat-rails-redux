class Api::V1::ChannelsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  after_action :verify_authorized, only: [ :index ]
  after_action :verify_policy_scoped, only: [ :index ]

  def index
    authorize Channel.new
    @channels = policy_scope(Channel)
  end

  def create
    @channel = Channel.new(channel_params)
    authorize @channel

    if @channel.save
      render :index
    else
      render_invalid_channel_error
    end
  end

  private

  def channel_params
    params.require(:channel).permit(:name)
  end

  def render_invalid_channel_error
    render json: { error: @channel.errors.full_messages },
      status: :unprocessable_entity
  end
end
