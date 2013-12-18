class Task < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :desc, :hours
end
