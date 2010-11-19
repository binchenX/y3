require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'


class HappyRobotController < ApplicationController
  def initialize
	

  end


  def run

    #Crawler_sjtu.run
    #Crawler_yuyingtang.run
    Crawler_maosh.run
   
    redirect_to posts_path
  end
 

end

class Douban

  def self.yuyingtang_event_uri
    "http://www.douban.com/host/yuyintang/events"
  end

  def self.maosh_event_uri
    "http://www.douban.com/host/maosh/events"
  end

  #return a Nokogiri HTML object
  def self.get url
    Nokogiri::HTML(open(url,:proxy => nil,'User-Agent' => 'ruby'),nil, "utf-8")
  end

   def self.is_event_link? href
    href.include?"event"
  end
end


 class Crawler_maosh
    def self.run
     page_uri = Douban.maosh_event_uri
     doc = Douban.get(page_uri)
     interested_posts_in_current_page = doc.xpath('//h2/a').select do |node|
        Douban.is_event_link? node['href']
     end
     interested_posts_in_current_page.each do |node|
        link =  node['href']
        title = "[MAO上海]"+node.text
        puts title + " link: " + link
        Post.new(:name => "happy_robot",:title => title,:content => link).save
    end
  end
 end

class Crawler_yuyingtang
  def self.run
     page_uri = Douban.yuyingtang_event_uri    
     doc = Douban.get(page_uri)
     interested_posts_in_current_page = doc.xpath('//h2/a').select do |node|
        Douban.is_event_link? node['href']
     end
     interested_posts_in_current_page.each do |node|
        link =  node['href']
        title = "[育音堂]"+node.text
        puts title + " link: " + link
        Post.new(:name => "happy_robot",:title => title,:content => link).save        
    end
  end
end

class Crawler_sjtu

  def self.is_post_link? href
    href.include?"reid"
  end

  def self.is_album_intr? title
    #contains [\347\256\200\344\273\213] - UTF-8
    title.include?"[简介]"
  end

  #the artist is right after [jian jie]
  def self.is_interested_author? title
    true
  end

  def self.run
    #this is the index page
    #@uri = "http://bbs.sjtu.edu.cn/bbstdoc,board,PopMusic.html"
    @sjtu_bbs_root_uri = "http://bbs.sjtu.edu.cn/"
    @sjtu_bbs_rock_index = @sjtu_bbs_root_uri + "/bbstdoc,board,PopMusic.html"
    #Alougth the site declared to be GB2312 ,but same character are actually not, which
    #will result in truncated document. Declaring it as GB18030 will solve this problem
    #the doc returned is alreayd UTF-8 coding. Cool!

    #get ten pages - we want to visit
    count = 0

    page_uri = @sjtu_bbs_rock_index

    begin

      puts "grab #{page_uri}"

      #proxy should not be used in when in home , you could either unset http_proxy
      #or set :proxy => nil
      #doc = Nokogiri::HTML(open(page_uri,:proxy => nil, 'User-Agent' => 'ruby'), nil, "GB18030")
      doc = Nokogiri::HTML(open(page_uri,:proxy => nil,'User-Agent' => 'ruby'), nil, "GB18030")

      interested_posts_in_current_page = doc.xpath('//a').select do |node|
        is_post_link? node['href'] and
          is_album_intr? node.text and
          is_interested_author? node.text
      end

      interested_posts_in_current_page.each do |node|
        link = @sjtu_bbs_root_uri + node['href']
        title = node.text

        puts title + " link: " + link

        #Let's save this post to our Model
        Post.new(:name => "happy_robot",:title => title,:content => link).save
      end

      previous_page_url =  @sjtu_bbs_root_uri + doc.xpath('//a').select {|node| node.text.include?"上一页"}.first["href"]

      #set up previous page uri for next iteration
      page_uri = previous_page_url
      count += 1
    end until (count == 10)

  end  #run


  
end