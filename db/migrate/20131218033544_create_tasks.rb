class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :user
      t.date :date
      t.string :desc
      t.float :hours

      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
