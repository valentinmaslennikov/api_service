class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
  	create_table :users do |t|
  		t.string :username, index: true
  		
  		t.timestamps
  	end
  end
end
