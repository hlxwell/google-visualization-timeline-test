# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_visualize_session',
  :secret      => '17e618bc2cea1958385881ca8eb627ce96b2adc53af30d4f924382cf694a3a3796f48572a65224a14531a1b2ceef169fde9d600bc44c031b3b5d0d19b40f6894'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
