require 'rails_helper'
require_relative '../support/api_helper'

RSpec.describe "API#PATCH_CHANNEL", type: :request do
  let!(:standard_user) { FactoryBot.create(:user) }
  let!(:another_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }
  let!(:unowned_channel) { FactoryBot.create(:channel) }
  let!(:standards_channel) { FactoryBot.create(:owned_channel, owner: standard_user) }
  let!(:admins_channel) { FactoryBot.create(:owned_channel, owner: admin_user) }

  let!(:parameters) { { channel: { name: "new_name" } } }

  def headers(user = standard_user)
    {
      "X-User-Email": user.email,
      "X-User-Token": user.authentication_token
    }
  end

  def call_patch(channel, hdr = headers, prm = parameters)
    patch "/api/v1/channels/#{channel.name}", params: prm, headers: hdr
  end

  def get_channel_name(channel)
    Channel.find(channel.id).name
  end

  def get_channel_owner(channel)
    Channel.find(channel.id).owner
  end

  # not authenticated
  context 'PATCH request when not logged in' do
    it 'returns status code 401 (unauthorized) and error about signing in when given no email' do
      call_patch(unowned_channel, without_key(headers, :"X-User-Email"))

      expect(response).to have_http_status(401)
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
    end

    it 'returns status code 401 (unauthorized) and error about signing in when given no token' do
      call_patch(unowned_channel, without_key(headers, :"X-User-Token"))

      expect(response).to have_http_status(401)
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
    end
  end

  # when authenticated
  context 'PATCH request when logged in' do
    # not owner or admin, on owned channel
    it 'returns status code 401 (unauthorised) when you are not owner or admin' do
      call_patch(standards_channel, headers(another_user))

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("Request declined. You are not an admin or owner of the channel.")
      expect(get_channel_name(standards_channel)).not_to eq("new_name")
    end

    # not owner or admin, on non-owned channel
    it 'returns status code 401 (unauthorised) when you are not owner or admin' do
      call_patch(unowned_channel)

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("Request declined. You are not an admin or owner of the channel.")
      expect(get_channel_name(unowned_channel)).not_to eq("new_name")
    end

    # owner of channel
    it 'successfully changes the channel name, when a standard user is owner of the channel' do
      call_patch(standards_channel)

      expect(response).to have_http_status(:success)
      expect(get_channel_name(standards_channel)).to eq("new_name")
    end

    # owner and admin of a channel
    it 'successfully changes the channel name, when an admin, and owner of the channel' do
      call_patch(admins_channel, headers(admin_user))

      expect(response).to have_http_status(:success)
      expect(get_channel_name(admins_channel)).to eq("new_name")
    end

    # admin, channel does not have owner
    it 'successfully changes the channel name of an unowned, when an admin' do
      call_patch(unowned_channel, headers(admin_user))

      expect(response).to have_http_status(:success)
      expect(get_channel_name(unowned_channel)).to eq("new_name")
    end

    # when admin and channel has a different owner
    it 'successfully changes the channel name, when an admin, but not owner of the channel' do
      call_patch(standards_channel, headers(admin_user))

      expect(response).to have_http_status(:success)
      expect(get_channel_name(standards_channel)).to eq("new_name")
    end

    it 'should fail by ignoring unpermitted params, such as owner, even for an admin' do
      call_patch(standards_channel, headers(admin_user), { channel: { owner: admin_user } })

      expect(response).to have_http_status(400) # bad content (no useful/valid params to update channel with)
      expect(get_error(response)).to eq("You need to supply a valid channel parameter to update, such as name.")
      expect(get_channel_owner(standards_channel)).to eq(standard_user)
    end

    it 'should fail by ignoring unpermitted params, such as owner, even for an the owner' do
      call_patch(standards_channel, headers(standard_user), { channel: { owner: admin_user } })

      expect(response).to have_http_status(400) # bad content (no useful/valid params to update channel with)
      expect(get_error(response)).to eq("You need to supply a valid channel parameter to update, such as name.")
      expect(get_channel_owner(standards_channel)).to eq(standard_user)
    end

    # general channel cannot be updated
    it 'should not be able to rename the general channel as an admin' do
      general_channel = FactoryBot.create(:channel, name: "general")

      call_patch(general_channel, headers(admin_user), { channel: { name: "new_name" } })
  
      expect(response).to have_http_status(400) # bad content
      expect(get_error(response)).to eq("Request declined. The #general channel's properties cannot be changed.")
      expect(Channel.find(general_channel.id).name).to eq("general")
    end
  end
end
