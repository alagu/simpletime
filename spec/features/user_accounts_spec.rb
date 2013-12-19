require 'spec_helper'

describe "UserAccounts" do
  include Warden::Test::Helpers
  Warden.test_mode!

  it "allows user to create an account" do
    register("tester@gmail.com", "my-password")

    page.should have_content("A message with a confirmation link has been sent to your email address")
    
    confirm_register_email

    page.should have_content("Your account was successfully confirmed. You are now signed in")
  end

  it "doesn't allow user to create a duplicate account" do
    user = FactoryGirl.build(:user)
    
    register(user.email, user.password)
    confirm_register_email

    logout(:user)

    visit "/"

    register(user.email, user.password)

    page.should have_content("Email has already been taken")
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
    user = FactoryGirl.create(:user)
    user.password = "wrong-password"

    login(user)

    page.should have_content("Invalid email or password")
  end

  it "allows user to set preferred working hours per day" do
    user = FactoryGirl.create(:user)
    
    login user

    visit "/users/edit"
    fill_in "Preferred hours per day", :with => "4"
    fill_in "Current password", :with => user.password

    click_button "Update"

    visit "/users/edit"

    find_field("Preferred hours per day").value.should eq "4.0"
  end

  it "doesn't allow user to edit another user's preferred working hours" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user, :email => Forgery(:internet).email_address)
    
    login user1
    visit "/users/edit"
    fill_in "Preferred hours per day", :with => "2"
    fill_in "Current password", :with => user1.password
    click_button "Update"

    logout(:user)

    login user2
    visit "/users/edit"

    find_field("Preferred hours per day").value.should_not == "2.0"
  end


end
