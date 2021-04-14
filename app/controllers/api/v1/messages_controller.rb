class Api::V1::MessagesController < ApplicationController
  before_action :set_channel, only: [ :index, :create ]

  def index
    @messages = @channel&.messages
  end

  def create
  end

  private

  def set_channel
    @channel = Channel.find_by(name: params[:channel_id])
  end
end
