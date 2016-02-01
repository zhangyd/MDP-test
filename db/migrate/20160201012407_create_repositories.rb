class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :url
      t.string :path
      t.string :owner
      t.string :email
      t.date :last_checked

      t.timestamps
    end
  end
end
