require 'spec_helper'

describe "Tasks" do
  it "allows user to add a new task what he worked on" do
    login

    page.should have_content("Record what you worked on")

    fill_in "What did you work on?", :with => "Built the user login feature"
    fill_in "When did you work?", :with => "18-12-2013"
    fill_in "How many hours?", :with => "2.5"

    click_button "Record"

    page.should have_content("Built the user login feature")
  end

  it "allows user to set preferred working hours per day" do
    user = login

    visit "/users/edit"
    fill_in "Preferred hours per day", :with => "4"
    fill_in "Current password", :with => user.password

    find_field("Preferred hours per day").value.should eq "4"

  end
end