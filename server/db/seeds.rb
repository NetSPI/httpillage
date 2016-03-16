# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Admin user for application
admin = User.create({
    :email => 'john@gmail.com',
    :password => 'topsecret',
    :password_confirmation => 'topsecret',
    :admin => true,
    :api_token => SecureRandom.base64(64),
    :api_token_changed => DateTime.now
})

# Create dictionary association
Dictionary.create({
  :filename => "28674f33a06c04e5e5d06bc20fb785fc98daf6ce1e11a6917f54906cba668ff0",
  :original_filename => "500-worst-passwords.txt",
  :description => "Database of the 500-worst passwords.",
  :file_size => 3502,
  :preview => "123456\n12345678\n1234\npussy\n12345\ndragon\nqwerty"
})

# Create API token for nodes to use when communicating with api
Setting.create(:key => 'nodeApi', :val => SecureRandom.base64(64))

Charset.create(:key => 'L', :val => ('a'..'z').to_a.join(""))
Charset.create(:key => 'U', :val => ('A'..'Z').to_a.join(""))
Charset.create(:key => 'D', :val => ('0'..'9').to_a.join(""))
Charset.create(:key => 'S', :val => (
    (' '..'/').to_a +
    (':'..'@').to_a +
    ("[".."`").to_a + 
    ("{".."~").to_a
    ).join(""))
