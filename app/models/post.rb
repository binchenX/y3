require 'voteable'

class Post < ActiveRecord::Base

  include Voteable
  
  validates :title, :presence=>true
  validates :title, :presence =>true,
              :length => { :minimum => 5 }


  has_many :comments
  belongs_to :user
  has_many :votes, :as => :voteable, :dependent => :destroy


#  def vote(post)
#    #self.votes.where(:user_id => post.id).first
#    self.votes.first
#  end

end
