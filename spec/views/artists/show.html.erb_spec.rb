require 'spec_helper'

describe "artists/show.html.erb" do
  before(:each) do
    @artist = assign(:artist, stub_model(Artist,
      :name => "Name",
      :intro => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
