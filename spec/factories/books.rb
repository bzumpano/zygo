FactoryBot.define do
  factory :book do
    title { Faker::Book.unique.title }
    description { Faker::Lorem.paragraph }
    image { Faker::Avatar.image }
    author { Faker::Book.author }
  end
end
