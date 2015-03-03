class AddSlug < ActiveRecord::Migration
  def change
    add_column :tasks, :slug, :string
    add_column :users, :slug, :string
    add_column :groups, :slug, :string
  end
end
