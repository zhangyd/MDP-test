class RemoveDetailsFromDependencies < ActiveRecord::Migration
  def change
    remove_column :dependencies, :dependency_id, :integer
    remove_column :dependencies, :repository_id, :integer
  end
end
