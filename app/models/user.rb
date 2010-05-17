class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :login
  end
end
