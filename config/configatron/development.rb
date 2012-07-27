# Override your default settings for the Development environment here.
# 
# Example:
#   configatron.file.storage = :local



APN::App::RAILS_ENV='development'
# development (delivery):
configatron.apn.passphrase = ''
configatron.apn.port = 2195
configatron.apn.host = 'gateway.sandbox.push.apple.com'
configatron.apn.cert = File.join(RAILS_ROOT, 'config', 'apple_push_notification_development.pem')

# # production (delivery):
# configatron.apn.host # => 'gateway.push.apple.com'
# configatron.apn.cert #=> File.join(RAILS_ROOT, 'config', 'apple_push_notification_production.pem')
# 
# # development (feedback):
# configatron.apn.feedback.passphrase # => ''
# configatron.apn.feedback.port # => 2196
# configatron.apn.feedback.host # => 'feedback.sandbox.push.apple.com'
# configatron.apn.feedback.cert #=> File.join(RAILS_ROOT, 'config', 'apple_push_notification_development.pem')
# 
# # production (feedback):
# configatron.apn.feedback.host # => 'feedback.push.apple.com'
# configatron.ap  n.feedback.cert #=> File.join(RAILS_ROOT, 'config', 'apple_push_notification_production.pem')