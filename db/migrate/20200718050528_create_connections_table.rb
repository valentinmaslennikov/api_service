# frozen_string_literal: true

class CreateConnectionsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.inet :ip
      t.references :user

      t.timestamps
    end
    add_index :connections, %i[ip user_id], unique: true
  end
end
