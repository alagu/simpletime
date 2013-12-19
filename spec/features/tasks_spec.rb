require 'spec_helper'

describe "Tasks" do
  include Warden::Test::Helpers
  Warden.test_mode!

  it "allows user to add a new task what he worked on" do
    user = FactoryGirl.create(:user)

    login user

    page.should have_content("Record what you worked on")
    create_task "Built the user login feature", "2.5", "18-12-2013"

    page.should have_content("Built the user login feature")
  end

  it "allows user to edit a created task" do
    user = FactoryGirl.create(:user)

    login user
    create_task "Built the login feature", "2.5", "19-12-2013"
    click_link "Edit"

    fill_in "Date", :with => "12-12-2013"
    fill_in "Hours", :with => "8"
    fill_in "Desc", :with => "Built the logout feature"
    click_button "Update Task"

    page.should have_content("12 December '13, Thursday")
    page.should have_content("8.0")
    page.should have_content("Built the logout feature")
  end

  it "allows user to delete a created task" do
    user = FactoryGirl.create(:user)

    login user
    create_task "Built the login feature", "2.5", "19-12-2013"

    page.should have_content("Built the login feature")

    click_link "Delete"

    page.should_not have_content("Built the login featurea")
  end

  it "doesn't show another users' tasks" do
    user1 = FactoryGirl.create(:user)
    login user1
    create_task "Built the login feature for user1", "2.5", "19-12-2013"
    logout(:user)

    user2 = FactoryGirl.create(:user, :email => Forgery(:internet).email_address)

    login user2
    create_task "Built the login feature for user2", "2.5", "19-12-2013"

    page.should have_content("Built the login feature for user2")
    page.should_not have_content("Built the login feature for user1")
  end

  it "doesn't allow user to see another user's task" do
    user1 = FactoryGirl.create(:user)

    login user1
    create_task "Built the login feature", "2.5", "19-12-2013"
    other_user_task = find_link("Built the login feature")
    logout(:user)

    user2 = FactoryGirl.create(:user, :email => Forgery(:internet).email_address)
    login user2

    visit other_user_task[:href]
    page.should have_content("You are not authorized to see a task which is not yours")
  end

  it "doesn't allow user to edit another user's task" do
    user1 = FactoryGirl.create(:user)

    login user1
    create_task "Built the login feature", "2.5", "19-12-2013"
    other_user_task = find_link("Edit")
    logout(:user)

    user2 = FactoryGirl.create(:user, :email => Forgery(:internet).email_address)
    login user2

    visit other_user_task[:href]
    page.should have_content("You are not authorized to edit a task which is not yours")
  end

  it "shows incomplete task if user has worked less than preferred working hours" do
    user = FactoryGirl.create(:user)

    login user

    create_task "Built the user login feature", "2.5", "18-12-2013"

    page.should have_css('div.date-box.incomplete')
  end

  it "shows complete task if user has worked more than preferred working hours " do
    user = FactoryGirl.create(:user)

    login user

    create_task "Built the user login feature", "8.5", "18-12-2013"

    page.should have_css('div.date-box.completed')

  end

  it "shows only rows in a specific date range" do
    user = FactoryGirl.create(:user)

    login user

    for date in 10..15 
      date_string = "#{date}-12-2013"

      for i in 1..3
        create_task "Built the user login feature", "2.5", date_string
      end
    end

    page.should have_content("14 December '13, Saturday") 

    visit "/dashboard?from=12-12-2013&to=13-12-2013"

    page.should have_content("12 December '13") 
    page.should have_content("13 December '13")

    page.should have_no_content("10 December '13")    
    page.should have_no_content("14 December '13")
  end

  it "allows to export tasks over a date range" do
    user = FactoryGirl.create(:user)

    login user

    for date in 10..15 
      date_string = "#{date}-12-2013"

      for i in 1..3
        create_task "Built the user login feature", "2.5", date_string
      end
    end

    click_link "Export"

    page.should have_no_content("Dashboard")
    page.should have_no_content("Record what you worked on")

    page.should have_content("12 December 2013")
    page.should have_content("13 December 2013")
  end
end