require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'

#return a Nokogiri XML  object
#use Douban API
def douban_get_xml url
 # Nokogiri::HTML(open(url,'User-Agent' => 'ruby'),nil, "utf-8")
   Nokogiri::HTML(open(url,:proxy => nil,'User-Agent' => 'ruby'),nil, "utf-8")
end



#return Atom 
def get key_chinese, location = "shanghai"

  keywords= "%" + key_chinese.each_byte.map {|c| c.to_s(16)}.join("%")
  uri="http://api.douban.com/events?q=#{keywords}&location=#{location}&start-index=2&max-results=1"
  douban_get_xml(uri)
end




def update artist
doc = get artist 
doc.xpath("//entry").each do |entry|
  #pp entry
  title = entry.at_xpath(".//title").text
  link =  entry.at_xpath(".//link[@rel='alternate']")["href"]
  #attribute is starttime NOT startTime as specified in the xml
  start = entry.at_xpath('.//when')["starttime"]
  city = entry.at_xpath('.//location').text
  where = entry.at_xpath('.//where')["valuestring"]
  puts title
  puts link
  puts start
  puts city
  puts where
end
end

File.read("artists.txt").split("\n").each do |artist|
	puts artist
	update artist
end
