class AddVotesModel < ActiveRecord::Migration
  def self.up
	create_table :votes do |t|
		t.boolean :like
		t.integer :user_id
		t.integer :voteable_id
		t.string  :voteable_type
		
		t.timestamps
	end	
  end

  def self.down
	drop_table :votes
  end
end
