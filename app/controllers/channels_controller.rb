class ChannelsController < ApplicationController
  def show
    if params[:id].blank?
      redirect_to channel_path("general")
    else
      @channel = Channel.find_by(name: params[:id])
      @channels = Channel.all
    end
  end
end
