class UsersController < ApplicationController


  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end



  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    #respond_to do |format|
      if @user.save
        #session[:user] = User.authenticate(@user.login, @user.password)
        flash[:notice] = "Registration successful"
        redirect_to root_url
        #format.html { redirect_to(@user, :notice => 'You have successfully registed.') }
        #format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        render :action => "new"
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    #end
  end

 
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

 




  

end
