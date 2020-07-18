class CreateConnectionsTable < ActiveRecord::Migration[6.0]
  def change
  	create_table :connections do |t|
  		t.inet :ip
  		t.references :user
  		
  		t.timestamps
  	end
  	add_index :connections, [:ip, :user_id], unique: true
  end
end
