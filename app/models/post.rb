require 'voteable'
require 'markdownable'

class Post < ActiveRecord::Base

  include Voteable
  include Markdownable



  acts_as_taggable
  validates :title, :presence =>true,
              :length => { :minimum => 5 }


  has_many :comments
  belongs_to :user
  has_many :votes, :as => :voteable, :dependent => :destroy


  def self.per_page
    10
  end

#  def vote(post)
#    #self.votes.where(:user_id => post.id).first
#    self.votes.first
#  end

end

