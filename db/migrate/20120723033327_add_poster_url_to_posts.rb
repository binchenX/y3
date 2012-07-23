class AddPosterUrlToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :image_small, :string
    add_column :posts, :image_mid, :string
    add_column :posts, :image_big, :string
  end

  def self.down
    remove_column :posts,:image_small
    remove_column :posts,:image_mid
    remove_column :posts,:image_big
  end
end
