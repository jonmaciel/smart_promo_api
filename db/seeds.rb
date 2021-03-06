require 'faker'

promotion_type_fidelity = PromotionType.create!(label: 'Programa de Fidelidade', slug: 'loyalty')
promotion_type_club = PromotionType.create!(label: 'Clube de Benefícios', slug: 'club')

customer = Customer.create!(
  name: 'Maciel',
  cpf: '07712973946',
)
wallet = Wallet.create(source: customer)

partner = Partner.create!(
  name: 'Empresa Doida',
  cnpj: '31698135000104',
  adress: 'adress',
  latitude: '-25.375435',
  longitude: '-49.254225'
)
Wallet.create(source: partner)

loyalty = Loyalty.create(partner: partner, customer: customer)

2.times do
  Promotion.create(
    name: Faker::Lorem.word,
    description: 'Fidelidade teste',
    promotion_type: promotion_type_fidelity,
    cost: 10,
    goal_quantity: 100,
    partner: partner,
  )
end

2.times do
  Promotion.create(
    name: Faker::Lorem.word,
    description: 'Clube de benefícios teste',
    promotion_type: promotion_type_club,
    partner: partner,
    cost: 1,
    goal_quantity: 50,
  )
end

sale = Sale.create(value_cents: 10000)

20.times do
  Ticket.create(
    sale: sale,
    partner: partner,
    wallet: wallet,
  )
end

sale = Sale.create(value_cents: 5000)

10.times do
  Ticket.create(
    sale: sale,
    partner: partner,
    wallet: wallet,
    contempled_promotion: Promotion.first
  )
end

Auth.create!(
  email: 'macielns@gmail.com',
  cellphone_number: '41992855072',
  password: '1234',
  password_confirmation: '1234',
  source: partner
)

Auth.create!(
  email: 'joaomaciel.n@gmail.com',
  cellphone_number: '41992855073',
  password: '1234',
  password_confirmation: '1234',
  source: customer
)
