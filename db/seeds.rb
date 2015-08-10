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

client = User.create( 
  password: '12345678', 
  email: 'client@example.com'
  )

driver = User.create( 
  password: '12345678', 
  email: 'driver@example.com',
  car_type: 1
  )

dispatcher = User.create( 
  password: '12345678', 
  email: 'dispatcher@example.com'
  )

admin = User.create( 
  password: '12345678', 
  email: 'admin@example.com'
  )

order = Order.create(
  status: 2, 
  departure: 'q',
  destination: '1',
  datetime: Time.now,
  car_type: 1,
  client: client,
  driver: driver
  )

client.roles << client_role
driver.roles << driver_role
dispatcher.roles << dispatcher_role
admin.roles << admin_role