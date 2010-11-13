require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'


@uri = "http://bbs.sjtu.edu.cn/bbstdoc,board,PopMusic.html"

#Alougth the site declared to be GB2312 ,but same character are actually not, which
#will result in truncated document. Declaring it as GB18030 will solve this problem
doc = Nokogiri::HTML(open(@uri), nil, "GB18030") 
doc.xpath('//a').each do |node|

  p node['href']	
  p node.text

end
