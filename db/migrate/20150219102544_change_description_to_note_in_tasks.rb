class ChangeDescriptionToNoteInTasks < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.rename :description, :note
    end
  end
end
