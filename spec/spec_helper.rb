# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
 
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

def login(user)
  visit "/"
  click_link "Sign in"

  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password

  click_button "Sign in"
end

def create_task(desc, hours, date)
  
  fill_in "What did you work on?", :with => desc
  fill_in "When did you work?", :with => date
  fill_in "How many hours?", :with => hours

  click_button "Record"
end

def register(email, pass)
  visit "/"
  click_link "Register"
  fill_in "Email", :with => email
  fill_in "Password", :with => pass
  fill_in "Password confirmation", :with => pass

  click_button "Sign up"
end

def confirm_register_email
  last_email = ActionMailer::Base.deliveries.last
  ctoken = last_email.body.match(/confirmation_token=\w*/)
  visit "/users/confirmation?#{ctoken}"
end