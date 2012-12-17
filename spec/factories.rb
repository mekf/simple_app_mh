FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { ('a'..'z').to_a.shuffle[0..7].join }
    password_confirmation { |u| u.password }
    remember_token { SecureRandom.urlsafe_base64 }
  end
end