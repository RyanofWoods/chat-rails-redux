class ChannelsController < ApplicationController
  def show
    if params[:id].blank?
      create_general_channel if Channel.count.zero?
      redirect_to channel_path("general")
    else
      @channel = Channel.find_by(name: params[:id])
      @channels = Channel.all
    end
  end

  private

  def create_general_channel
    Channel.create(name: "general")
  end
end
