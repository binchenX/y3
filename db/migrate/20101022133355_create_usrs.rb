class CreateUsrs < ActiveRecord::Migration
  def self.up
    create_table :usrs do |t|
      t.string :name
      t.integer :credit
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :usrs
  end
end
