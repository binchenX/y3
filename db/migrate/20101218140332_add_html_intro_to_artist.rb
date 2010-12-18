class AddHtmlIntroToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :html_intro, :text
  end

  def self.down
    remove_column :artists, :html_intro
  end
end
