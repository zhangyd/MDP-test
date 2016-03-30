class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :repo_id
      t.string :filename

      t.timestamps
    end
  end
end
