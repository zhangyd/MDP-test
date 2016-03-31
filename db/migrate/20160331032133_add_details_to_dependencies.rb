class AddDetailsToDependencies < ActiveRecord::Migration
  def change
    add_column :dependencies, :file_name, :string
    add_column :dependencies, :file_path, :string
    add_column :dependencies, :md5, :string
    add_column :dependencies, :sha1, :string
    add_column :dependencies, :num_evidence, :int
    add_column :dependencies, :descriptions, :string
  end
end
