require 'pry-byebug'

class Api::V1::MessagesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_channel, only: [ :index, :create ]

  def index
    @messages = @channel&.messages
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.channel = @channel

    authorize @message

    if @message.save
      render :index
    else
      render_error
    end
  end

  private

  def set_channel
    @channel = Channel.find_by(name: params[:channel_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def render_error
    render json: { errors: @message.errors.full_messages },
      status: :unprocessable_entity
  end
end
