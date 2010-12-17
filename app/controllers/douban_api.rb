require 'open-uri'

def get key_chinese, location

keywords= "%" + key_chinese.each_byte.map {|c| c.to_s(16)}.join("%")
uri="http://api.douban.com/events?q=#{keywords}&location=#{location}&start-index=2&max-results=1"
open(uri) {|f| f.each_line {|l| puts l}}


end


#get "秋天", "beijing"

get "马条", "shanghai"
