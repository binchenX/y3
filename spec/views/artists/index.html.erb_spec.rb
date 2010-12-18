require 'spec_helper'

describe "artists/index.html.erb" do
  before(:each) do
    assign(:artists, [
      stub_model(Artist,
        :name => "Name",
        :intro => "MyText"
      ),
      stub_model(Artist,
        :name => "Name",
        :intro => "MyText"
      )
    ])
  end

  it "renders a list of artists" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
