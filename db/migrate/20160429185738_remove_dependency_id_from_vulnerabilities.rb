class RemoveDependencyIdFromVulnerabilities < ActiveRecord::Migration
  def change
    remove_column :vulnerabilities, :dependency_id, :string
  end
end
