require 'faker'

5.times do
  Promotion.create(
    name: Faker::Lorem.word
  )
end

lists = Promotion.all
partner = Partner.create(
  name: 'Maciel',
  adress: 'test',
  cnpj: '31.698.135/0001-04',
  adress: 'adress',
  latitude: '-25.375435',
  longitude: '-49.254225'
)

user = Auth.create!(
  email: 'joaomaciel.n@mail.com',
  password: '123123123',
  password_confirmation: '123123123',
  source: partner
)


