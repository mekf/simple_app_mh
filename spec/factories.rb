FactoryGirl.define do
  factory :user do
    name "Tester"
    email "tester@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end