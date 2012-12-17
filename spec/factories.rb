FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { ('a'..'z').to_a.shuffle[0..5].join }
    password_confirmation { |u| u.password }
    remember_token { SecureRandom.urlsafe_base64 }
  end

  # factory with sequence
  # factory :user do
  #   sequence(:name) { |n| "Person #{n}" }
  #   sequence(:email) { |n| "person_#{n}@example.org" }
  #   password { ('a'..'z').to_a.shuffle[0..5].join }
  #   password_confirmation { |u| u.password }
  #   remember_token { SecureRandom.urlsafe_base64 }
  # end
end