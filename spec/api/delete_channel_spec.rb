require 'rails_helper'
require_relative '../support/api_helper'

RSpec.describe "API#DELETE_CHANNEL", type: :request do
  let!(:standard_user) { FactoryBot.create(:user) }
  let!(:another_user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }
  let!(:unowned_channel) { FactoryBot.build(:channel) }
  let!(:standards_channel) { FactoryBot.build(:owned_channel, owner: standard_user) }
  let!(:admins_channel) { FactoryBot.build(:owned_channel, owner: admin_user) }

  def headers(user = standard_user)
    {
      "X-User-Email": user.email,
      "X-User-Token": user.authentication_token
    }
  end

  def call_delete(channel, hdr = headers)
    delete "/api/v1/channels/#{channel.name}", headers: hdr
  end

  # not authenticated
  context 'DELETE request when not authenticated' do
    it 'returns status code 401 (unauthorized) and error about signing in when given no email' do
      unowned_channel.save!
      call_delete(unowned_channel, without_key(headers, :"X-User-Email"))

      expect(response).to have_http_status(401)
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
      expect(Channel.find(unowned_channel.id)).not_to be(nil)
    end

    it 'returns status code 401 (unauthorized) and error about signing in when given no token' do
      unowned_channel.save!
      call_delete(unowned_channel, without_key(headers, :"X-User-Token"))

      expect(response).to have_http_status(401)
      expect(get_error(response)).to eq("You need to sign in or sign up before continuing.")
      expect(Channel.find(unowned_channel.id)).not_to be(nil)
    end
  end

  # when authenticated
  context 'DELETE request when authenticated' do
    # standard user trying to delete another users channel
    it 'should fail and return status code 401 (unauthorised) when you are not owner or admin' do
      standards_channel.save!
      call_delete(standards_channel, headers(another_user))

      expect(response).to have_http_status(401) # not authorized
      expect(get_error(response)).to eq("Request declined. You are not an admin or owner of the channel.")
      expect(Channel.find(standards_channel.id)).not_to be(nil)
    end

    # standard user deleting their own channel
    it 'should pass and return status code success when you are are owner of the channel' do
      standards_channel.save!
      count_before = Channel.count

      call_delete(standards_channel, headers(standard_user))

      expect(response).to have_http_status(:success)
      expect(Channel.count).to eq(count_before - 1)
    end

    # admin user deleting another users' channel
    it 'should pass and return status code success when you are are an admin' do
      standards_channel.save!
      count_before = Channel.count

      call_delete(standards_channel, headers(admin_user))

      expect(response).to have_http_status(:success)
      expect(Channel.count).to eq(count_before - 1)
    end

    # admin user deleting their own channel
    it 'should pass and return status code success when you are are an admin and owner' do
      admins_channel.save!
      count_before = Channel.count

      call_delete(admins_channel, headers(admin_user))

      expect(response).to have_http_status(:success)
      expect(Channel.count).to eq(count_before - 1)
    end
  end
end
