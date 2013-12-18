class Task < ActiveRecord::Base
  belongs_to :user
  attr_accessible :date, :desc, :hours
  accepts_nested_attributes_for :user
end
