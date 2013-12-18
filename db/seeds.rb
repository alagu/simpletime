User.delete_all
Task.delete_all

user = User.create(email: 'allagappan@gmail.com', password: 'simpletime')
user.confirm!

for dd in 10..19
  for i in 1..rand(1..3)
    desc = "Created a #{Forgery(:basic).color} ball for #{Forgery(:name).first_name} #{Forgery(:name).last_name
}"
    puts desc
    t = Task.create(desc: desc, date: Date.parse("#{dd}-12-2013"), :hours => 4)
    t.user = user
    t.save!
  end
end