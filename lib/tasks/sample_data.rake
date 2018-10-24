#Used to create 99 fake users for testing
#Next, we’ll add a Rake task to create sample users. Rake tasks live in the lib/tasks directory, and are defined using namespaces (in this case, :db), as seen in Listing 9.29. (This is a bit advanced, so don’t worry too much about the details.)
#To generate new sample data each time stuff is added to file you must run db:populate (See pg. 535)


namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do             #This line ensures that the Rake task has access to the local Rails environment, including the User model 

    admin = User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true)

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end


    #Creating fake microposts
    users = User.all(limit: 6) #Adding sample micro- posts for all the users actually takes a rather long time, so first we’ll select just the first six users3 using the :limit option to the User.all method:4
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end

  end
end