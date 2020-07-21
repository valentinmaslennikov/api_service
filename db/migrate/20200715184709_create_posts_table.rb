class CreatePostsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.inet :ip
      t.integer :avg_rating, index: true
      t.integer :rating_count, default: 0
      t.integer :rating_value, default: 0
      t.references :user

      t.timestamps
    end
  end
end
