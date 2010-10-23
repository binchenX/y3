class User < ActiveRecord::Base

  acts_as_authentic

  validates :login, :presence=>true
  #validates :hashed_password, :hashed_password=>true
  #validates :email, :presence=>true

  has_many :posts
  has_many :comments

#
#  def self.authenticate(login, pass)
#    u = find(:first, :conditions=>["login = ?", login])
#    return nil if u.nil?
#    #return u if User.encrypt(pass, u.salt)==u.hashed_password
#    return u if pass == u.hashed_password
#    nil
#  end



#  def password
#    self.hashed_password
#  end
#
#
#  def password=(pass)
#    #TODO: encrypt it later
#    self.hashed_password = pass
#  end





end
