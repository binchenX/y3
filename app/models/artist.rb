class Artist < ActiveRecord::Base
  before_save :generate_html_intro

  
  def generate_html_intro
    #this function will called when update
    self.html_intro = RDiscount.new(intro).to_html
  end

end
