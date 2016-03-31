class RemovePathFromRepository < ActiveRecord::Migration
  def change
    remove_column :repositories, :path, :string
  end
end
