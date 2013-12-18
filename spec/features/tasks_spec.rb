require 'spec_helper'

describe "Tasks" do
  it "allows user to add a new task what he worked on" do
    visit "/"
    click_link "Sign in"

    user = FactoryGirl.create(:user)

    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password

    click_button "Sign in"

    page.should have_content("Record what you worked on")

    fill_in "What did you work on?", :with => "Built the user login feature"
    fill_in "When did you work?", :with => "18-12-2013"
    fill_in "How many hours?", :with => "2.5"

    click_button "Record"

    page.should have_content("Built the user login feature")
  end
end