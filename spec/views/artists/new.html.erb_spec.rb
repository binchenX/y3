require 'spec_helper'

describe "artists/new.html.erb" do
  before(:each) do
    assign(:artist, stub_model(Artist,
      :name => "MyString",
      :intro => "MyText"
    ).as_new_record)
  end

  it "renders new artist form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => artists_path, :method => "post" do
      assert_select "input#artist_name", :name => "artist[name]"
      assert_select "textarea#artist_intro", :name => "artist[intro]"
    end
  end
end
