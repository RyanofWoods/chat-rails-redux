def sign_in!
  sign_in :user, FactoryBot.create(:user)
end
