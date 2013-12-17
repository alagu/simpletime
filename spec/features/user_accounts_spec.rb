require 'spec_helper'

describe "UserAccounts" do
  it "allows user to create an account" do
    visit "/"
    click_link "Register"
    fill_in "Email", :with => "tester@gmail.com"
    fill_in "Password", :with => "my-password"
    click_button "Register"

    page.should have_content("Email confirmation sent to tester@gmail.com")
  end

end
