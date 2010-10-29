class AddVotePointsToPosts < ActiveRecord::Migration
  def self.up
	add_column :posts,:vote_points, :integer, :default => 0
  end

  def self.down
	remove_column :posts,:vote_points
  end
end
