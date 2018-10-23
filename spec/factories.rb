FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }            #The block variable n is automatically incremented, so that the first user has name “Person 1” and email address “person_1@example.com”, the second user has name “Person 2” and email address “person_2@example.com”, and so on. 
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do     #To write tests for the delete functionality, it’s helpful to be able to have a factory to create admins. We can accomplish this by adding an :admin block to our factories, as shown in Listing 9.41. We can now user FactoryGirl.create(:admin) to create an administative user in our tests. (Pg. 495) 
      admin true
    end
  end 
end