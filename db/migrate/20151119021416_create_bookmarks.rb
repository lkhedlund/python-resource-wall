class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :article_id
      t.integer :user_id
      t.timestamps
      t.references :user
      t.references :article
    end
  end
end
