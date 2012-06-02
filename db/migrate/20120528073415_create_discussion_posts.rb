class CreateDiscussionPosts < ActiveRecord::Migration
  def self.up
    create_table :discussion_posts do |t|
      t.string :author
      t.text :content
      t.integer :web_id

      t.timestamps
    end
  end

  def self.down
    drop_table :discussion_posts
  end
end
