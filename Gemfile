 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.0'

#Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "will_paginate", "~> 3.0.pre2"
gem "authlogic", :git => "git://github.com/odorcicd/authlogic.git", :branch => "rails3"
gem "inherited_resources", "~> 1.1.2"
gem "rdiscount"
gem "haml", "~> 3.0.13"
gem "formtastic", "~> 1.1.0"
gem "acts-as-taggable-on", "~> 2.0.6"
gem "simple-rss"
gem "doubapi" , "~> 0.1.3"
gem "toPinyin", "~> 0.0.5"
gem "apn_on_rails"
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
	
# end

#need to comment out before pushing to heroku
# gem 'sqlite3-ruby', :require => 'sqlite3'
 group  :development do
   gem 'rspec-rails','2.0.1'
   gem 'sqlite3-ruby', :require => 'sqlite3'
 end

 group :production do
  gem 'pg' 
end
 
group  :test do
   gem "autotest"
   gem "autotest-rails", "~> 4.1.0"
   gem 'rspec', '2.0.1'	
   gem 'webrat'
   gem 'rspec-rails','2.0.1'
 end
