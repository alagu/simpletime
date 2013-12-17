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
  end

end
