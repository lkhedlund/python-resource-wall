class User < ActiveRecord::Base
  has_many :articles
  has_many :bookmarks
  has_many :comments
  has_many :likes

  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    message: "Please enter a valid email address." } }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}
end