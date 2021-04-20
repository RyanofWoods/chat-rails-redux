class Api::V1::ChannelsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_channel, only: [:update, :destroy]
  after_action :verify_authorized, only: [:index, :update, :destroy]
  after_action :verify_policy_scoped, only: [:index]

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

  def update
    authorize @channel

    render_bad_content if channel_params == {}

    @channel.update(channel_params)
  end

  def destroy
    authorize @channel
  end

  private

  def set_channel
    @channel = Channel.find_by(name: params[:id])
  end

  def channel_params
    params.require(:channel).permit(:name)
  end

  def render_bad_content
    render json: { error: "You need to supply a valid channel parameter to update, such as name." },
           status: :bad_request
  end

  def render_invalid_channel_error
    render json: { error: @channel.errors.full_messages },
           status: :unprocessable_entity
  end
end
