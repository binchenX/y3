require 'apn_on_rails'

class NotificationController < ApplicationController
  
 
  class << self
   
    def getAppId
      
      #if no app ,create one
      if(APN::App.count == 0 )
        app = APN::App.create(:apn_dev_cert => File.read(configatron.apn.cert), :apn_prod_cert => nil)
      end
      
      #return the id
      APN::App.first.id

    end
    
    #rf:rd
    def registerDevice token
      
        if(APN::Device.find_by_token(token).nil?)
          device = APN::Device.create(:token => token,:app_id => getAppId)   
          if(device != nil)
            puts "new device createid id: #{device.id}, token:#{device.token}"
          else
            puts "fail to register device token :#{token}"
          end
        else
          puts "device already registered"
        end
    end
    
    #rf:sn
    def sendNotifications
      
      #find all devices and send the notification
      APN::Device.all.each do |device|
          notification = APN::Notification.new   
          notification.device = device  
          notification.badge = 2   
          notification.sound = true   
          notification.alert = "New Album udpated."   
          notification.save
      end
      puts "notifcations created, waiting issue cmd: bundle exec rake apn:notifications:deliver"
    end
    

  end
  
  #"http://localhost:3000/nc?func=registerDevice&&token=aa307ed3%2076daca14%20befcd16a%2042535ddd%20742640f5%209c067710%20d91a0a48%20dd6a08c4"
  def nc
    result = "ok"
    function = params[:func]
    if(function.eql?("registerDevice"))
      token = params[:token]
      NotificationController.registerDevice(token)
    end
    response = {}
    response["status"] = result
    render :layout => false ,:json => response.to_json
  end
  
  
end