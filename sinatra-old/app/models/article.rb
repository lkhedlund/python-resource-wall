class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :likes
  has_many :bookmarks

  validates :title, presence: true
  validates :url, presence: true, format: { with: /\b(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\b/,
    message: "Please enter a valid URL beginning with http:// or https://" }
  validates :image, presence: true
end