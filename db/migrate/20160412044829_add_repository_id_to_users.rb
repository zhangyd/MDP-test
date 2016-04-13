class AddRepositoryIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :repository_id, :integer
  end
end
