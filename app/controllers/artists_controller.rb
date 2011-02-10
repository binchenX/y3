class ArtistsController < InheritedResources::Base

	protected
		def collection
			#@artists = Artist.find(:all,:group => "name" ,:order => "name")
			@artists = Artist.find(:all,:order => "name")
		end
end
