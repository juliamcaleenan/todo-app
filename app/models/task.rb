class Task < ActiveRecord::Base
  include Sluggable

  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :assignee, class_name: "User", foreign_key: "assigned_to"
  belongs_to :group

  validates :title, presence: true
  validates :priority, presence: true

  sluggable_column :title
end