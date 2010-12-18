require 'spec_helper'

describe ArtistsController do

  def mock_artist(stubs={})
    (@mock_artist ||= mock_model(Artist).as_null_object).tap do |artist|
      artist.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all artists as @artists" do
      Artist.stub(:all) { [mock_artist] }
      get :index
      assigns(:artists).should eq([mock_artist])
    end
  end

  describe "GET show" do
    it "assigns the requested artist as @artist" do
      Artist.stub(:find).with("37") { mock_artist }
      get :show, :id => "37"
      assigns(:artist).should be(mock_artist)
    end
  end

  describe "GET new" do
    it "assigns a new artist as @artist" do
      Artist.stub(:new) { mock_artist }
      get :new
      assigns(:artist).should be(mock_artist)
    end
  end

  describe "GET edit" do
    it "assigns the requested artist as @artist" do
      Artist.stub(:find).with("37") { mock_artist }
      get :edit, :id => "37"
      assigns(:artist).should be(mock_artist)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created artist as @artist" do
        Artist.stub(:new).with({'these' => 'params'}) { mock_artist(:save => true) }
        post :create, :artist => {'these' => 'params'}
        assigns(:artist).should be(mock_artist)
      end

      it "redirects to the created artist" do
        Artist.stub(:new) { mock_artist(:save => true) }
        post :create, :artist => {}
        response.should redirect_to(artist_url(mock_artist))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved artist as @artist" do
        Artist.stub(:new).with({'these' => 'params'}) { mock_artist(:save => false) }
        post :create, :artist => {'these' => 'params'}
        assigns(:artist).should be(mock_artist)
      end

      it "re-renders the 'new' template" do
        Artist.stub(:new) { mock_artist(:save => false) }
        post :create, :artist => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested artist" do
        Artist.should_receive(:find).with("37") { mock_artist }
        mock_artist.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :artist => {'these' => 'params'}
      end

      it "assigns the requested artist as @artist" do
        Artist.stub(:find) { mock_artist(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:artist).should be(mock_artist)
      end

      it "redirects to the artist" do
        Artist.stub(:find) { mock_artist(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(artist_url(mock_artist))
      end
    end

    describe "with invalid params" do
      it "assigns the artist as @artist" do
        Artist.stub(:find) { mock_artist(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:artist).should be(mock_artist)
      end

      it "re-renders the 'edit' template" do
        Artist.stub(:find) { mock_artist(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested artist" do
      Artist.should_receive(:find).with("37") { mock_artist }
      mock_artist.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the artists list" do
      Artist.stub(:find) { mock_artist }
      delete :destroy, :id => "1"
      response.should redirect_to(artists_url)
    end
  end

end
