RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'authlogic'
  config.gem 'formtastic'
  config.gem 'haml'
  config.gem 'russian'
  config.gem 'factory_girl' 
  config.gem 'will_paginate'

  config.time_zone = 'Novosibirsk'
end

require "will_paginate"
