#encoding: utf-8

require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'
#require 'douban_api'
require 'doubapi'
require 'rdiscount'
#encoding: utf-8

class HappyRobotController < ApplicationController
  def initialize
	

  end

  def run
=begin
    #SJTU site has some encoding problem when working with PG database, it is fine with Sqlite
    #Crawler_sjtu.run
    Douban.hosts.each {|host|
      puts "happy_robot will crawl #{host}"
      Cralwer_douban_events.crawl(host)
    }
=end
	redirect_to posts_path
  end
	
  #To be used from http requst
  def cs1 
	HappyRobotController.crawl_shows_by_artists
	redirect_to posts_path
  end

  def cs2 
	HappyRobotController.crawl_shows_in_shanghai
	redirect_to posts_path
  end

  def ca
	HappyRobotController.crawl_albums
	redirect_to posts_path
  end

  #To be used in the Rake task
  class << self

    def crawl_albums
		Douban.crawl_albums_by_artist   
    end 

  	def crawl_shows_in_shanghai
		Douban.crawl_music_events_of_all_artists
  	end

  	def crawl_shows_by_artists
		Douban.crawl_events_by_artist
	end
  
  end #class << self
end

Event = Struct.new :title, :link ,:date

Album = Struct.new :title, :link

class Where

  def self.in_company?
    #change to false when deploying
    #true
    false
  end
end


class Douban

  #instance method 
  class << self
  def hosts
    [
      "http://www.douban.com/host/yuyintang/events",
      "http://www.douban.com/host/maosh/events",
      "http://www.douban.com/host/lostmusic/events",
      "http://www.douban.com/host/zjdreams/events",
      "http://www.douban.com/host/livebar696/events",
      "http://www.douban.com/host/maolivehouse/events"

    ]
  end

  #return a Nokogiri HTML object
  def get url
    if Where.in_company?
      #proxy needed.
      Nokogiri::HTML(open(url,'User-Agent' => 'ruby'),nil, "utf-8")
    else
      Nokogiri::HTML(open(url,:proxy => nil,'User-Agent' => 'ruby'),nil, "utf-8")
    end
    #For use within company network
    #Nokogiri::HTML(open(url,'User-Agent' => 'ruby'),nil, "utf-8")
  end

  def is_event_link? href
    href.include?"event"
  end

  #return Time object
  #date format is:s
  #"时间：2010年8月13日 周五 21:30 -  23:55"
  #or
  #2010-08-13F21:30:00+08:00
  def parse_date date
    year, month , day = date.scan(/\d{1,4}/)
    Time.local(year,month,day)
  end

def crawl_albums_by_artist

  Artist.all.each do |artist|
    puts "search albums for " + artist.name

    Doubapi.search_albums_of(:singer=>artist.name, :since=>"2010.01") do |album|
      puts album.author        
      puts album.release_date  
      puts album.title         
      puts album.link   


      #post_title = "[#{album.author}] #{album.title}"
      #modified for iOs app - title only , no author
      post_title = album.title
      markdown_content = album.title + "\n\n" + album.link	
      if Post.find_all_by_name_and_title("happy_robot",post_title).empty? 
        Post.new(:name => "happy_robot",
                :title => post_title,
        	      :content => markdown_content ,
        	      :tag_list => "album,专辑 ,#{album.author}",
        	      :happen_at => album.release_date,
                :image_small => album.cover_thumbnail,
                :image_mid => album.cover_thumbnail,
                :image_big => album.cover_thumbnail,
                :singer => album.author
        	).save
      end #if not exsits
    end #each albums
  end#each artists
end


  def save_show_events events ,who="AllArtists"
	
	events.each do |event|
        puts event.title
        puts event.when
        puts event.where
        puts event.what

        happen_at = Douban.parse_date(event.when).strftime("%Y-%m-%d");
		#strip the tab/space at the begin of each scentence 
		#"\n\n" is needed so it can be display correctly
		markdown_content = event.what.split("\n").map {|s| s.lstrip}.join("\n\n")

        if Post.find_all_by_name_and_title("happy_robot",event.title).empty? and Douban.parse_date(event.when) > Time.now 
			Post.new(:name => "happy_robot",
        	:title => event.title,
         	:content => markdown_content ,
          	:tag_list => "show, 演出 , #{who}",
          	:happen_at => happen_at
       		).save
		end
	end
  end

  def crawl_music_events_of_all_artists
  
      total , e = Doubapi.search_events_of(:key=>"all",:location => "shanghai")
      save_show_events e
  end

  def crawl_events_by_artist
    #Let's use douban API
    Artist.all.each do |artist|
      puts "search events for " + artist.name
      total, e = Doubapi.search_events_of(:key=>artist.name,:location => "shanghai")
   
	  #comment out :tag_list when test
	  #e = search_events_of "许巍"
      #e = search_events_of "野孩子" 
      save_show_events e,artist.name 
      
	 end
  end#define crawl_by_artist

end #class << self
end


#As we will crawl every day, it is enough to just crawl the first page 


class Cralwer_douban_events

  def self.crawl page_uri

    doc = Douban.get(page_uri)

    events = doc.css("div.nof.clearfix").map do |eventnode|
      name = eventnode.at_css("h2 a").text.strip
      link = eventnode.at_css("h2 a")['href']
      #intro includes : date &  place
      #"时间：2010年8月13日 周五 21:30 -  23:55\n
      # 地点：上海 长宁区 淮海西路570号32幢 MAO livehouse上海店\n
      # 发起人：MAO LIVEHOUSE 上海店  \n             \n
      # 224人参加   799人感兴趣"
      intro = eventnode.at_css("div.pl.intro").text.strip
      date = intro.split("\n").first.strip
      Event.new name , link , date
    end

    today = Time.now
    #save only events that are
    #1. has not happened and
    #2. has not been posted/crawled
    events.select { |event|

      #true #for test
      Douban.parse_date(event.date) > today and
        Post.find_all_by_name_and_title("happy_robot",event.title).empty?
    }.each {|e|
      #grab the content pointed by e.link
      detail_page = Douban.get(e.link)
      html_content = detail_page.css("div.wr#edesc_s").to_s
      html_content << "[来源]" + e.link
      happen_at = Douban.parse_date(e.date).strftime("%Y-%m-%d");
      Post.new(:name => "happy_robot",
        :title => e.title,
        :content => html_content,
        :tag_list => "show, 演出",
        :happen_at => happen_at
      ).save
      
    }

  end
end

class Crawler_sjtu

  def self.get uri
    if Where.in_company?
      Nokogiri::HTML(open(uri,'User-Agent' => 'ruby'), nil, "GB18030")
    else
      Nokogiri::HTML(open(uri,:proxy => nil,'User-Agent' => 'ruby'), nil, "GB18030")
    end
    
  end
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

    page_uri = @sjtu_bbs_rock_index

    #5 page should be enough if we crawl every day
    5.times {

      puts "grab #{page_uri}"

     
      doc = get page_uri

      interested_posts_in_current_page = doc.xpath('//a').select do |node|
        is_post_link? node['href'] and
          is_album_intr? node.text and
          is_interested_author? node.text
      end

      #if we have not saved it , save it
      interested_posts_in_current_page.each.select {|node|
        Post.find_all_by_name_and_title("happy_robot", node.text).empty?
      }.each do |node|
        link = @sjtu_bbs_root_uri + node['href']
        title = node.text
        puts title + " link: " + link
        #go and grab the post

        post = get(link)
        #1. why .first?
        #    the first <pre> element is the original post , others are replies
        #2. why  [2..-3]  
        #   remove the first two lines, and last 2 lines ,
        #
        # <pre>
        #[<a href="bbspst?board=PopMusic&amp;file=M.1287289219.A">回复本文</a>] 发信人: <a href="bbsqry?userid=InnJayHee">InnJayHee</a>(loser), 信区: PopMusic
        #正文  <-- this is what we interested
        #<font class="c37"></font><font class="c34">※ 来源:·饮水思源 bbs.sjtu.edu.cn·[FROM: 222.134.174.29]</font><font class="c37">
        #</font></pre>
        #
        html_content = '<pre>' <<
          post.css('pre').first.to_s.split("\n")[2..-3].join("\n") <<
          '</pre>' <<
          "来源" + link
        #Let's save this post to our Model
        Post.new(:name => "happy_robot",:title => title,:content => html_content, :tag_list => "album,专辑").save
      end

      previous_page_url =  @sjtu_bbs_root_uri + doc.xpath('//a').select {|node| node.text.include?"上一页"}.first["href"]

      #set up previous page uri for next iteration
      page_uri = previous_page_url
      
    }

  end  #run


  
end
