class AddUserpathToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :userpath, :string
  end
end
