class UserSessionsController < ApplicationController

  # GET /user_sessions/new
  # GET/user_sessions/login.xml
  def new
    @user_session = UserSession.new
  end


  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])

    #respond_to do |format|
      if @user_session.save
        flash[:notice] = "Successfully logged in"
        redirect_to root_url
        #format.html { redirect_to(@post, :notice => 'You now login in.') }
        # format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        #flash[:notice] = "In valid user"
        render :action => "new"
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    #end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out"
    redirect_to posts_url
  end


  
end
