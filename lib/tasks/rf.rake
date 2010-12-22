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


	desc "crawl new information"
	task :crawl => :environment do 
		puts "start crawling..."
	end

end
