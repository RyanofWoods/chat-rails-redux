def signup!
  visit '/users/sign_up'

  within("#new_user") do
    fill_in 'user_username', with: 'test_username'
    fill_in 'user_email', with: 'user@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
  end

  click_button 'Sign up'
end

def login!
  User.find_by(username: 'test_username') || User.create!(email: 'user@example.com', password: 'password', username: "test_username" )

  visit '/users/sign_in'

  within("#new_user") do
    fill_in 'user_email', with: 'user@example.com'
    fill_in 'user_password', with: 'password'
  end

  click_button 'Log in'
end

describe "user can sign up and login", type: :feature do
  it "user can signup" do
    signup!()
    expect(page).to have_content 'signed up successfully.'
  end

  it "user can login" do
    login!()
    expect(page).to have_content 'Signed in successfully.'
  end
end
