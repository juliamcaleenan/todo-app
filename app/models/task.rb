class Task < ActiveRecord::Base

  belongs_to :creator, class_name: "User", foreign_key: "created_by"
  belongs_to :assignee, class_name: "User", foreign_key: "assigned_to"

  validates :title, presence: true
  validates :priority, presence: true

end