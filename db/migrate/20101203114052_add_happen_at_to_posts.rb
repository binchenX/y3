class AddHappenAtToPosts < ActiveRecord::Migration
  def self.up
     add_column :posts, :happen_at, :datetime
  end

  def self.down
    remove_column :posts, :happen_at
  end
end
