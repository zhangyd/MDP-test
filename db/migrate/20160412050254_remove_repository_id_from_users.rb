class RemoveRepositoryIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :repository_id, :integer
  end
end
