#Used to create 99 fake users for testing
#Next, we’ll add a Rake task to create sample users. Rake tasks live in the lib/tasks directory, and are defined using namespaces (in this case, :db), as seen in Listing 9.29. (This is a bit advanced, so don’t worry too much about the details.)
#To generate new sample data each time stuff is added to file you must run db:populate (See pg. 535)


namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do   #This line ensures that the Rake task has access to the local Rails environment, including the User model 
    make_users
    make_microposts
    make_relationships
  end 
end

def make_users
  admin = User.create!(name:      "Kris OMeara",   
                       email:     "omear048@gmail.com",
                       password:  "password",
                       password_confirmation: "password",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end 
end

def make_microposts   #View page 600 for info around this and resetting the DB
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships 
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end



