require 'toPinyin'
class ArtistsController < InheritedResources::Base

	protected
		def collection
			#@artists = Artist.find(:all,:group => "name" ,:order => "name")
			@artists = Artist.all.sort {|a, b| a.name.pinyin.join <=> b.name.pinyin.join}
		end
end
