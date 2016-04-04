class AddRepositoryIdToDependencies < ActiveRecord::Migration
  def change
    add_column :dependencies, :repository_id, :integer
  end
end
