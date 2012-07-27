require 'apn_on_rails'

class NotificationController < ApplicationController
  
  
  
  class << self
    
    def sendNotifications
      
      app = APN::App.create(:apn_dev_cert => File.read(configatron.apn.cert), :apn_prod_cert => nil)
      device = APN::Device.create(:token => "aa307ed3 76daca14 befcd16a 42535ddd 742640f5 9c067710 d91a0a48 dd6a08c4",:app_id => app.id)   
      notification = APN::Notification.new   
      notification.device = device  
      notification.badge = 5   
      notification.sound = true   
      notification.alert = "My first push"   
      notification.save
      
        puts "sendNotifications in NotificationController"
    end
    
    
  end
  
  
end