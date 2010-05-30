class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :login
    config.validates_format_of_login_field_options = {
      :with => /^\w[-._\w\d]+$/,
      :message => "должен содержать только буквы, цифры и .-_"
    }
  end

  attr_protected :login

  has_many :firmwares
  has_many :matches

  def owns?(obj)
    obj.respond_to? :user and obj.user == self
  end
end
