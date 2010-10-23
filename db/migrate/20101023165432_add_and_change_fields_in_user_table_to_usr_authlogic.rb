class AddAndChangeFieldsInUserTableToUsrAuthlogic < ActiveRecord::Migration
  def self.up
    add_column :users, :persistence_token, :string;
    rename_column :users, :hashed_password , :crypted_password;
    rename_column :users, :salt , :password_salt;

  end

  def self.down
    remove_column :users, :persistence_token, :string;
    rename_column :users, :crypted_password , :hashed_password ;
    rename_column :users, :password_salt,     :salt;
  end
end
