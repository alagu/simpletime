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

  it "allows user to edit a created task" do
    pending "add here"
  end

  it "allows user to delete a created task" do
    pending "add here"
  end

  it "doesn't allow user to delete another user's task" do
    pending "add here"
  end

  it "doesn't allow user to edit another user's task" do
    pending "add here"
  end

  it "shows incomplete task if user has worked less than preferred working hours" do
    user = login

    fill_in "What did you work on?", :with => "Built the user login feature"
    fill_in "When did you work?", :with => "18-12-2013"
    fill_in "How many hours?", :with => "2.5"

    click_button "Record"

    page.should have_css('div.date-box.incomplete')
  end

  it "shows complete task if user has worked more than preferred working hours " do
    user = login

    fill_in "What did you work on?", :with => "Built the user login feature"
    fill_in "When did you work?", :with => "18-12-2013"
    fill_in "How many hours?", :with => "8.5"

    click_button "Record"

    page.should have_css('div.date-box.completed')

  end
end