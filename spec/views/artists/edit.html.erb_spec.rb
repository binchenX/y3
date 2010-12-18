require 'spec_helper'

describe "artists/edit.html.erb" do
  before(:each) do
    @artist = assign(:artist, stub_model(Artist,
      :new_record? => false,
      :name => "MyString",
      :intro => "MyText"
    ))
  end

  it "renders the edit artist form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => artist_path(@artist), :method => "post" do
      assert_select "input#artist_name", :name => "artist[name]"
      assert_select "textarea#artist_intro", :name => "artist[intro]"
    end
  end
end
