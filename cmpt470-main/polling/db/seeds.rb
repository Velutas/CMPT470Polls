# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(
    name: 'Admin', 
    email: 'kstory@sfu.ca', 
    password: 'cmpt470pw',
    user_type: 2, 
    contact_visibility: 2, 
    response_visibility: 2,
    activated: true,
    activated_at: Time.zone.now
)
User.create!(
    name: 'Moderator', 
    email: 'kenstoryx@gmail.com', 
    password: 'cmpt470pw',
    user_type: 1, 
    contact_visibility: 1, 
    response_visibility: 1,
    activated: true,
    activated_at: Time.zone.now
)
User.create!(
    name: 'Test', 
    email: 'test@gmail.com', 
    password: 'cmpt470pw',
    user_type: 0, 
    contact_visibility: 1, 
    response_visibility: 1,
    activated: true,
    activated_at: Time.zone.now
)

# Email Testing
# Populated with data based on rails tutorial for account activation at
# https://www.railstutorial.org/book/account_activation_password_reset
User.create!(
    name:  "Example User",
    email: "example@railstutorial.org",
    password: "foobar55",
    password_confirmation: "foobar55",
    activated: true,
    activated_at: Time.zone.now
)

99.times do |n|
    name  = Faker::Name.name
    email = "example#{n+1}@railstutorial.org"
    password = "password"
    puts "#{email}"
    User.create!(
        name:  name,
        email: email,
        password: password,
        password_confirmation: password,
        activated: true,
        activated_at: Time.zone.now
    )
end



