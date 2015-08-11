# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

client_role = Role.create(name: 'client')
driver_role = Role.create(name: 'driver')
dispatcher_role = Role.create(name: 'dispatcher')
admin_role = Role.create(name: 'admin')

client1 = User.create( 
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  phone: Faker::PhoneNumber.cell_phone,
  password: '12345678', 
  email: 'client1@example.com'
  )
client1.roles << client_role

client2 = User.create( 
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  phone: Faker::PhoneNumber.cell_phone,
  password: '12345678', 
  email: 'client2@example.com'
  )
client2.roles << client_role

driver1 = User.create( 
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  phone: Faker::PhoneNumber.cell_phone,
  password: '12345678', 
  email: 'driver1@example.com',
  car_type: 1
  )
driver1.roles << driver_role

driver2 = User.create( 
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  phone: Faker::PhoneNumber.cell_phone,
  password: '12345678', 
  email: 'driver2@example.com',
  car_type: 1
  )
driver2.roles << driver_role

dispatcher = User.create( 
  firstname: Faker::Name.first_name,
  lastname: Faker::Name.last_name,
  phone: Faker::PhoneNumber.cell_phone,
  password: '12345678', 
  email: 'dispatcher@example.com'
  )
dispatcher.roles << dispatcher_role

admin = User.create(
  password: '12345678', 
  email: 'admin@example.com'
  )
admin.roles << admin_role

order1 = Order.create(
  status: 0, 
  departure: Faker::Address.street_address,
  destination: Faker::Address.street_address,
  datetime: Faker::Time.between(DateTime.now - 1, DateTime.now),
  car_type: 1,
  client: client1,
  driver: driver1
  )

order2 = Order.create(
  status: 2, 
  departure: Faker::Address.street_address,
  destination: Faker::Address.street_address,
  datetime: Faker::Time.between(DateTime.now - 1, DateTime.now),
  car_type: 1,
  client: client2,
  driver: driver2
  )

order3 = Order.create(
  status: 0, 
  departure: Faker::Address.street_address,
  destination: Faker::Address.street_address,
  datetime: Faker::Time.between(DateTime.now - 1, DateTime.now),
  car_type: 1,
  client: client1,
  driver: driver2
  )

order4 = Order.create(
  status: 0, 
  departure: Faker::Address.street_address,
  destination: Faker::Address.street_address,
  datetime: Faker::Time.between(DateTime.now - 1, DateTime.now),
  car_type: 1,
  client: client2,
  driver: driver1
  )

order5 = Order.create(
  status: 1, 
  departure: Faker::Address.street_address,
  destination: Faker::Address.street_address,
  datetime: Faker::Time.between(DateTime.now - 1, DateTime.now),
  car_type: 1,
  client: client2,
  driver: driver2
  )

order6 = Order.create(
  status: 3, 
  departure: Faker::Address.street_address,
  destination: Faker::Address.street_address,
  datetime: Faker::Time.between(DateTime.now - 1, DateTime.now),
  car_type: 1,
  client: client1,
  driver: driver2
  )