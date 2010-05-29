Factory.sequence :user_name do |n|
  "User_#{n}"
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |u|
  u.login { Factory.next :user_name }
  u.email { Factory.next :email }
  u.password "1234"
  u.password_confirmation "1234"
end

Factory.define :firmware do |fw|
  fw.name "Best WaFfLe fw"
  fw.association :user
end

Factory.define :firmware_version do |fwv|
  fwv.code "a = 2"
  fwv.association :firmware
end

Factory.define :match do |m|
  m.association :first_version, :factory => :firmware_version
  m.association :second_version, :factory => :firmware_version
end
