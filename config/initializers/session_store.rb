# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_application_session',
  :secret      => '825e9099e36b43464960b13aaee0e7e319bfbd276e54182c4b31b6a1ea12227f87accb14c9738db45ba9ee9f6528d9230eb194663437684e759a9423f90ee94f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
