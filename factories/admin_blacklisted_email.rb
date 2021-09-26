require 'faker'

FactoryBot.define do
  factory :admin_banned_email, class: AdminBlacklistedEmail do
    email
  end
end
