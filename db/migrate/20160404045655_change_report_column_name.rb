class ChangeReportColumnName < ActiveRecord::Migration
  def change
  	rename_column :reports, :repo_id, :repository_id
  end
end
