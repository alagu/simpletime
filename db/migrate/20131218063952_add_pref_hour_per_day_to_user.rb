class AddPrefHourPerDayToUser < ActiveRecord::Migration
  def change
    add_column :users, :pref_hours, :float, :default => 8
  end
end
