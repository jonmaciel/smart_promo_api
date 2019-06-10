require 'faker'

promotion_type_fidelity = PromotionType.create!(label: 'Programa de Fidelidade')
promotion_type_club = PromotionType.create!(label: 'Clube de Benefícios')

2.times do
  Promotion.create(
    name: Faker::Lorem.word,
    promotion_type: promotion_type_fidelity
  )
end

2.times do
  Promotion.create(
    name: Faker::Lorem.word,
    promotion_type: promotion_type_club
  )
end

lists = Promotion.all
customer = Customer.create!(
  name: 'Maciel',
  cpf: '07712973946',
)
partner = Partner.create!(
  name: 'Maciel',
  cnpj: '31698135000104',
  adress: 'adress',
  latitude: '-25.375435',
  longitude: '-49.254225'
)

2.times do
  Ticket.create(
    name: 'test',
    partner: partner,
    promotion_type: promotion_type_fidelity
  )
end

2.times do
  Promotion.create(
    partner: partner,
    promotion_type: promotion_type_club
  )
end

user = Auth.create!(
  email: 'joaomaciel.n@gmail.com',
  cellphone_number: '41992855073',
  password: '1234',
  password_confirmation: '1234',
  source: customer
)

loyalty = Loyalty.create(partner: partner, customer: customer)
Wallet.create(source: customer)
