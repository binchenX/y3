module Markdownable
  def self.included(base)
    base.class_eval do
      before_save :generate_html_content
     
    end
  end

  def generate_html_content
    #for post crawled by happy robot , no need to convert to html.
    #when the post is posted by the user, the html_content is nil ,so convert the conent, which is
    #a markdown to the html format
    #when the post is posted by the happy_robot, the html_conent , grabed directly from the website,
    #is not nil.

    #this function will called when update
    #if not self.content.nil?  #post by the User, we have to convert content to html_content
      self.html_content = RDiscount.new(content).to_html
    #end
  end


  
end
