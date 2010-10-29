class DeleteAllPosts < ActiveRecord::Migration
  def self.up
	Post.delete_all

  end

  def self.down
  end
end
