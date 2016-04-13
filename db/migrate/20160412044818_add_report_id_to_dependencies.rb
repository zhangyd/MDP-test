class AddReportIdToDependencies < ActiveRecord::Migration
  def change
    add_column :dependencies, :report_id, :integer
  end
end
