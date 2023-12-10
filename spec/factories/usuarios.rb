FactoryBot.define do
  factory :usuario do
    email { "email@email.com" }
    password { "password" }
    invitation_accepted_at { 1.day.ago }
  end
end
