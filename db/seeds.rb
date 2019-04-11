require 'faker'

20.times do
  Promotion.create(
    name: Faker::Lorem.word
  )
end

lists = Promotion.all

# for each Todo List, add 5 Items
lists.each do |list|
  5.times do
    list.prizes.create(
      name: Faker::Lorem.word,
    )
  end
end

