class AddDependencyIdToDependencies < ActiveRecord::Migration
  def change
    add_column :dependencies, :dependency_id, :integer
  end
end
