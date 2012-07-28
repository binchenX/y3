 'http://rubygems.org'
source :gemcutter

gem 'rails', '3.0.0'


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
