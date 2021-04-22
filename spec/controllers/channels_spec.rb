require 'rails_helper'
require_relative "../support/devise_helper"

RSpec.describe ChannelsController, type: :controller do
  context "#show" do
    it "with no channel should redirect to channels/general" do
      FactoryBot.create(:channel)
      FactoryBot.create(:channel, name: "general")

      sign_in!
      get :show

      expect(response).to redirect_to("/channels/general")
    end

    it "if there are no channels it should create a general channel then redirect to it" do
      Channel.destroy_all

      sign_in!
      get :show

      expect(Channel.count).to eq(1)
      expect(Channel.first.name).to eq("general")
      expect(response).to redirect_to("/channels/general")
    end
  end
end
