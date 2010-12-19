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
def search key_chinese, location = "shanghai"
  keywords= "%" + key_chinese.each_byte.map {|c| c.to_s(16)}.join("%")
  uri="http://api.douban.com/events?q=#{keywords}&location=#{location}&start-index=2&max-results=1"
  douban_get_xml(uri)
end


Douban_Event =  Struct.new :title, :when, :where, :what,:link

def search_events_of artist
  doc = search artist
  events=[]
  doc.xpath("//entry").each do |entry|
    #pp entry
    title = entry.at_xpath(".//title").text
    #attribute is starttime NOT startTime as specified in the xml
    start_time = entry.at_xpath('.//when')["starttime"]
    #  city = entry.at_xpath('.//location').text
    where = entry.at_xpath('.//where')["valuestring"]
    link =  entry.at_xpath(".//link[@rel='alternate']")["href"]
    what = entry.at_xpath(".//content").text
    events << Douban_Event.new(title, start_time, where, what, link)
  end
  events
end


#TEST....

#should use Artist Model
#File.read("./app/controllers/artists.txt").split("\n").each {|artist| Artist.new(:name=>artist,:intro=>"no").save}
#Artist.all.each {|a| puts a.name}
File.read("artists.txt").split("\n").each do |artist|
	puts artist
	e = search_events_of artist
  e.each do |event|
    puts event.title
    puts event.when
    puts event.where
    puts event.what

  end
end

