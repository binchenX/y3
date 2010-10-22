class User < ActiveRecord::Base

  validates :login, :presence=>true
  #validates :hashed_password, :hashed_password=>true
  #validates :email, :presence=>true

  has_many :posts
  has_many :comments


  def password
    self.hashed_password
  end


  def password=(pass)
    #TODO: encrypt it later
    self.hashed_password = pass
  end


#  def name
#    self.login
#  end
  

end
