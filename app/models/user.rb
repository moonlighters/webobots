class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :login
  end

  attr_protected :login
end
