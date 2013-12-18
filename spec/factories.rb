FactoryGirl.define do
  factory :user do
    email "test@gmail.com"
    password  "mypassword"
    confirmed_at          Time.now
  end
end