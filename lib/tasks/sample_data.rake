namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin1 = User.create!(name: "Minh Ha",
                         email: "nhat.minh.ha@gmail.com",
                         password: "t3mppassword",
                         password_confirmation: "t3mppassword")
    admin1.toggle!(:admin)

    admin2 = User.create!(name: "Minh Ha Admin2",
                         email: "minh.katze@gmail.com",
                         password: "t3mppassword",
                         password_confirmation: "t3mppassword")
    admin2.toggle!(:admin)

    normal_me = User.create!(name: "Minh Ha Normal",
                         email: "minh.katze@normal.com",
                         password: "t3mppassword",
                         password_confirmation: "t3mppassword")

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = ('a'..'z').to_a.shuffle[0..5].join
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end