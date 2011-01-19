RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'authlogic'
  config.gem 'formtastic'
  config.gem 'haml'
  config.gem 'russian'
  config.gem 'factory_girl'
  config.gem 'will_paginate'
  config.gem 'recaptcha', :lib => 'recaptcha/rails'
  config.gem 'acts_as_commentable', :version => '<3.0.0'
  config.gem 'gravtastic'
  config.gem 'log_buddy'
  config.gem 'friendly_id', :version => '>=3.2.0'
  config.gem 'hoptoad_notifier'

  config.time_zone = 'Novosibirsk'
end
