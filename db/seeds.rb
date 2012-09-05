# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => 'administrator', :first_name => 'admin', :password => 'admin', :password_confirmation => 'admin', :last_name => 'admin', :email => 'nitinbarai.virtueinfo@gmail.com', :contact => '9033194939', :is_admin => 1, :is_active => 1)

User.create(:username => 'eugene', :first_name => 'eugene', :password => 'eugene', :password_confirmation => 'eugene', :last_name => 'eugene', :email => 'eugene@gmail.com', :contact => '9033194939', :is_admin => 0, :is_active => 1)
