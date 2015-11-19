class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment
      t.integer :article_id
      t.integer :user_id
      t.timestamps
      t.references :user
      t.references :article
    end
  end
end
