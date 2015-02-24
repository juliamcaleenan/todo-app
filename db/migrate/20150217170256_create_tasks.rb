class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.boolean :completed
      t.string :priority
      t.integer :created_by
      t.integer :assigned_to
      t.timestamps
    end
  end
end
