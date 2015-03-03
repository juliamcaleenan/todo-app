class User < ActiveRecord::Base
  include Sluggable

  has_many :tasks
  has_many :user_groups
  has_many :groups, through: :user_groups

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}, on: :create

  sluggable_column :username
end