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

  # 1234 - спец. универсальный код для тестового окружения
  u.code '1234'
end

Factory.define :firmware do |fw|
  fw.name "Best WaFfLe fw"
  fw.association :user
  fw.shared false
  fw.available true
end

Factory.define :firmware_version do |fwv|
  fwv.code "a = 2"
  fwv.association :firmware
  fwv.after_create { |v| v.firmware.reload }
end

# этот Factory ничерта не работает если добавить ассоциацию user
# из-за проверки принадлежности одной из прошивок юзеру
Factory.define :match do |m|
  m.association :first_version, :factory => :firmware_version
  m.association :second_version, :factory => :firmware_version
end

Factory.define :invite do |i|
  i.comment "for Mr.Smith"
end
