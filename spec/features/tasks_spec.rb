require 'spec_helper'

describe "Tasks" do
  it "allows user to add a new task what he worked on" do
    login

    page.should have_content("Record what you worked on")
    create_task "Built the user login feature", "2.5", "18-12-2013"

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
    login

    create_task "Built the user login feature", "2.5", "18-12-2013"

    page.should have_css('div.date-box.incomplete')
  end

  it "shows complete task if user has worked more than preferred working hours " do
    user = login

    create_task "Built the user login feature", "8.5", "18-12-2013"

    page.should have_css('div.date-box.completed')

  end

  it "shows only rows in a specific date range" do
    login

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
    user = login

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