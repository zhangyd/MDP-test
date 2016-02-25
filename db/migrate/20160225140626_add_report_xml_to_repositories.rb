class AddReportXmlToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :report_xml, :string
  end
end
