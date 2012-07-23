class AddSingerToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts ,:singer ,:string
  end

  def self.down
    remove_column :posts, :singer
  end
end
