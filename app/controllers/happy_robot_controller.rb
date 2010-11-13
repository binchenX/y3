require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'

#this is the index page 
#@uri = "http://bbs.sjtu.edu.cn/bbstdoc,board,PopMusic.html"
@sjtu_bbs_root_uri = "http://bbs.sjtu.edu.cn/"
@sjtu_bbs_rock_index = @sjtu_bbs_root_uri + "/bbstdoc,board,PopMusic.html"
#Alougth the site declared to be GB2312 ,but same character are actually not, which
#will result in truncated document. Declaring it as GB18030 will solve this problem
#the doc returned is alreayd UTF-8 coding. Cool!



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


#get ten pages - we want to visit
count = 0 

page_uri = @sjtu_bbs_rock_index

begin

puts "grab #{page_uri}"
doc = Nokogiri::HTML(open(page_uri), nil, "GB18030") 

interested_posts_in_current_page = doc.xpath('//a').select do |node|
isPostLink? node['href'] and 
isAlbumIntr? node.text and
isInterestedAuthor? node.text 
end

interested_posts_in_current_page.each do |node|
link = node['href']	
title = node.text

puts title + "like:" + @sjtu_bbs_root_uri + link 
end

previous_page_url =  @sjtu_bbs_root_uri + doc.xpath('//a').select {|node| node.text.include?"上一页"}.first["href"] 

#go and grab another page
puts previous_page_url

#prepare for grab next page
page_uri = previous_page_url
count += 1
end until (count == 10)
