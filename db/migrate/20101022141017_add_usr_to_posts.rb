class AddUsrToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :usr_id, :integer
  end

  def self.down
    remove_column :posts, :usr_id
  end
end
