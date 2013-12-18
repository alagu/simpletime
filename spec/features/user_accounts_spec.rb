require 'spec_helper'

describe "UserAccounts" do
  it "allows user to create an account" do
    visit "/"
    click_link "Register"
    fill_in "Email", :with => "tester@gmail.com"
    fill_in "Password", :with => "my-password"
    fill_in "Password confirmation", :with => "my-password"

    click_button "Sign up"

    page.should have_content("A message with a confirmation link has been sent to your email address")
  
    last_email = ActionMailer::Base.deliveries.last
    ctoken = last_email.body.match(/confirmation_token=\w*/)
    visit "/users/confirmation?#{ctoken}"
    
    page.should have_content("Your account was successfully confirmed. You are now signed in")
  end

  it "allows user to login into the app" do
    visit "/"
    click_link "Sign in"

    user = FactoryGirl.create(:user)

    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password

    click_button "Sign in"

    page.should have_content("Signed in successfully")
  end

end
