require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'

#return a Nokogiri XML  object
#use Douban API
def douban_get_xml url
  Nokogiri::HTML(open(url,'User-Agent' => 'ruby'),nil, "utf-8")
end



#return Atom 
def get key_chinese, location

  keywords= "%" + key_chinese.each_byte.map {|c| c.to_s(16)}.join("%")
  uri="http://api.douban.com/events?q=#{keywords}&location=#{location}&start-index=2&max-results=1"
  douban_get_xml(uri)
end



doc = get "马条", "shanghai"
doc.xpath("//entry").each do |entry|
  #pp entry
  puts entry.at_xpath("//id").text
  title = entry.xpath("//title").text
  link = entry.at_xpath("//link[@rel='alternate']")["href"]
  puts title
  puts link
end
