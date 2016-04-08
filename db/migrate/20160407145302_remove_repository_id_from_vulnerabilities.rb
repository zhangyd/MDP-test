class RemoveRepositoryIdFromVulnerabilities < ActiveRecord::Migration
  def change
    remove_column :vulnerabilities, :repository_id, :integer
  end
end
