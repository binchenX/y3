class AddHtmlContentToPost < ActiveRecord::Migration
  def self.up
	add_column :posts, :html_content, :text
  end

  def self.down
	remove_column :posts, :html_content
  end
end
