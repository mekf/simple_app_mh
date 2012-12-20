FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(6) }
    password_confirmation { |u| u.password }
    remember_token { SecureRandom.urlsafe_base64 }

    factory :admin do
      sequence (:email) { |n| "admin_#{n}@admin.org" }
      admin true
    end
  end

  # factory with sequence
  # factory :user do
  #   sequence(:name) { |n| "Person #{n}" }
  #   sequence(:email) { |n| "person_#{n}@example.org" }
  #   password { ('a'..'z').to_a.shuffle[0..5].join }
  #   password_confirmation { |u| u.password }
  #   remember_token { SecureRandom.urlsafe_base64 }
  # end

  factory :micropost do
    content { Faker::Lorem.sentence }
    # user_id { rand(0..99) } # fail as the user_id cannot be manually assigned
    user
    created_at { rand(0..9).hour.ago }
  end
end