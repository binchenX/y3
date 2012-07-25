class AddLinkMobileToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :link_mobile , :string
  end

  def self.down
    remove_column :posts, :link_mobile
  end
end
