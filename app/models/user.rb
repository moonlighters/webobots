class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :login
  end

  attr_protected :login

  has_many :firmwares

  def owns?(obj)
    obj.respond_to? :user and obj.user == self
  end
end
