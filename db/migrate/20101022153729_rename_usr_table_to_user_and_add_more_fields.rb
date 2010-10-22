class RenameUsrTableToUserAndAddMoreFields < ActiveRecord::Migration
  def self.up

    rename_table :usrs , :users;

    add_column :users, :salt, :string;
    add_column :users, :hashed_password, :string;

    rename_column :users, :name , :login;
  end

  def self.down
    rename_table :users , :usrs;

    remove_column :usrs , :salt;
    remove_column :usrs, :hashed_password;

    rename_column :usrs, :login, :name;
  end
end
