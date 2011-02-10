class ArtistsController < InheritedResources::Base

	protected
		def collection
			@artists = Artist.find(:all,:group => "name" ,:order => "name")
		end
end
