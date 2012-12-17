FactoryGirl.define do
  factory :user do
    name "Tester"
    email "tester@testing.com"
    password "foobar"
    password_confirmation "foobar"
    remember_token "L4QywjQ7Taxzc1YehFQGoA"

    factory :signup_user do
      name "Signup"
      email "signup@testing.com"
    end
  end
end