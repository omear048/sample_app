#Used to create 99 fake users for testing
#Next, we’ll add a Rake task to create sample users. Rake tasks live in the lib/tasks directory, and are defined using namespaces (in this case, :db), as seen in Listing 9.29. (This is a bit advanced, so don’t worry too much about the details.)

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
  end
end