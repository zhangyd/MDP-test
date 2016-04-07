class AddRepoIdToVulnerabilities < ActiveRecord::Migration
  def change
    add_column :vulnerabilities, :repository_id, :integer
  end
end
