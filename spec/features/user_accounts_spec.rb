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

  it "doesn't allow user to create a duplicate account" do
    pending "add here"
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

  it "doesn't allow user to login with wrong password" do
    pending "add here"
  end



  it "allows user to set preferred working hours per day" do
    user = login

    visit "/users/edit"
    fill_in "Preferred hours per day", :with => "4"
    fill_in "Current password", :with => user.password

    find_field("Preferred hours per day").value.should eq "4"
  end

  it "doesn't allow user to edit another user's preferred working hours" do
    pending "add here"
  end


end
