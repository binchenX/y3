namespace :rf do 
	
	desc "Add Artists from public/artist.txt"
	task :aa => :environment do

		f = File.join(RAILS_ROOT,"public","artists.txt")

		File.read(f).split("\n").each do |artist|
			 if Artist.find_all_by_name(artist).empty?
				 puts "add new artist #{artist}"
				 Artist.new(:name=>artist,:intro=>"no").save
			 end
		end
	
		#Artist.all.each {|a| puts a.name}
		puts "add artists"
	end	


	desc "crawl ALL new information(albums,shows)"
	task :c => [:ca,:cs] do 
		puts "start crawling ALL new informations"
	end

	desc "crawl new ablbums"
	task :ca => :environment do 
		puts "start crawling albums.."
		HappyRobotController.crawl_albums
		puts "Finish crawling albums.."
	end
	
	desc "crawl live rock shows by intersted artists"
	task :cs1 => :environment do 
		puts "start crawling rock shows by artists"
		HappyRobotController.crawl_shows_by_artists
		puts "Finish crawling rock_shows by artists"
	end

	desc "crawl new live rock shows in Douban shanghai events (all artists)"
	task :cs2 => :environment do 
		puts "start crawling rock shows in shanghai"
		HappyRobotController.crawl_shows_in_shanghai
		puts "Finish crawling rock_shows in shanghai"
	end
	
    desc "crawl all the live rock show information by all means"
	task :cs => [:cs1, :cs2] do 
		puts "craw all live shows.."
	end
	
	desc "register devices "
	task :rd => :environment do
	  deviceToken = "aa307ed3 76daca14 befcd16a 42535ddd 742640f5 9c067710 d91a0a48 dd6a08c4"
	  NotificationController.registerDevice(deviceToken)
	  puts "device #{deviceToken} registered"
	end
	
	desc "send notifications to APN"
	task :sn => :environment do
	  NotificationController.sendNotifications
	  puts "send notifications"
	end

end
