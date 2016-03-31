class AddRepopathToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :repopath, :string
  end
end
