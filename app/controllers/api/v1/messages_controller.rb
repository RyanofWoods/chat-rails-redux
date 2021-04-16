class Api::V1::MessagesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_channel, only: [ :index, :create ]

  def index
    authorize Message.new

    if @channel
      @messages = @channel.messages
    else
      render_invalid_channel_error
    end
  end

  def create
    @message = Message.new(message_params)
    authorize @message

    if @channel
      @message.user = current_user
      @message.channel = @channel

      if @message.save
        render :index
      else
        render_invalid_message_error
      end
    else
      render_invalid_channel_error
    end
  end

  private

  def set_channel
    @channel = Channel.find_by(name: params[:channel_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def render_invalid_message_error
    render json: { error: @message.errors.full_messages },
      status: :unprocessable_entity
  end

  def render_invalid_channel_error
    render json: { error: "This channel does not exist." },
      status: :unprocessable_entity
  end
end
