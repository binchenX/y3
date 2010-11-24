require 'rubygems'  #a hack to require failure for nokogiri
require 'open-uri'
require 'nokogiri'
require 'pp'


class HappyRobotController < ApplicationController
  def initialize
	

  end


  def run

    Crawler_sjtu.run
    Douban.hosts.each {|host| Cralwer_douban_events.crawl(host) }
    redirect_to posts_path
  end
 

end

Event = Struct.new :title, :link ,:date

Album = Struct.new :title, :link

class Douban

  def self.hosts
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
  def self.get url
    Nokogiri::HTML(open(url,:proxy => nil,'User-Agent' => 'ruby'),nil, "utf-8")
  end

  def self.is_event_link? href
    href.include?"event"
  end

  #return Time object
  #date format is
  #"时间：2010年8月13日 周五 21:30 -  23:55"
  def self.parse_date date
    year, month , day = date.scan(/\d{1,4}/)
    Time.local(year,month,day)
  end
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
      Douban.parse_date(event.date) > today and
      Post.find_all_by_name_and_title("happy_robot",event.title).empty?
    }.each {|e|
      #grab the content pointed by e.link
      detail_page = Douban.get(e.link)
      html_content = detail_page.css("div.wr#edesc_s").to_s
      html_content << "来源" + e.link
      Post.new(:name => "happy_robot",:title => e.title,:html_content => html_content,:tag_list => "show, 演出").save
      
      }

  end
end

class Crawler_sjtu

  def self.get uri
     #proxy should not be used in when in home , you could either unset http_proxy
     #or set :proxy => nil
     #doc = Nokogiri::HTML(open(page_uri,:proxy => nil, 'User-Agent' => 'ruby'), nil, "GB18030")
    Nokogiri::HTML(open(uri,:proxy => nil,'User-Agent' => 'ruby'), nil, "GB18030")
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
        Post.new(:name => "happy_robot",:title => title,:html_content => html_content, :tag_list => "album,专辑").save
      end

      previous_page_url =  @sjtu_bbs_root_uri + doc.xpath('//a').select {|node| node.text.include?"上一页"}.first["href"]

      #set up previous page uri for next iteration
      page_uri = previous_page_url
      
    }

  end  #run


  
end