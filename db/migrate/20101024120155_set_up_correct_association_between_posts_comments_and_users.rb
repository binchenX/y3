class SetUpCorrectAssociationBetweenPostsCommentsAndUsers < ActiveRecord::Migration
  def self.up
	rename_column :comments, :usr_id, :user_id
	rename_column :posts,    :usr_id, :user_id
  end

  def self.down
	rename_column :comments, :user_id, :usr_id
	rename_column :posts,    :user_id, :usr_id
  end
end
