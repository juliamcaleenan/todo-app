class Group < ActiveRecord::Base
  include Sluggable

  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :tasks
  belongs_to :creator, class_name: "User", foreign_key: "created_by"

  has_secure_password validations: false
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 5}, on: :create

  sluggable_column :name
end