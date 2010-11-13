require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'

#this is the index page 
#@uri = "http://bbs.sjtu.edu.cn/bbstdoc,board,PopMusic.html"

@uri = "http://bbs.sjtu.edu.cn/bbstdoc,board,PopMusic,Page,175.html"

#Alougth the site declared to be GB2312 ,but same character are actually not, which
#will result in truncated document. Declaring it as GB18030 will solve this problem
doc = Nokogiri::HTML(open(@uri), nil, "GB18030") 

#select only the post links

def isPostLink? href
	href.include?"reid"
end

def isAlbumIntr? title
	#contains [\347\256\200\344\273\213] - UTF-8
	title.include?"[简介]"
end

#the artist is right after [jian jie]
def isInterestedAuthor? title
	true
end

posts_in_current_page = doc.xpath('//a').select do |node|
	isPostLink? node['href'] and 
	isAlbumIntr? node.text and
	isInterestedAuthor? node.text 
end

posts_in_current_page.each do |node|

   link = node['href']	
   title = node.text

   puts title
   puts link 
end 
