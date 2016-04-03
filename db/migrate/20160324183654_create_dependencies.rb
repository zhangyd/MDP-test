class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
    	t.string :file_name
    	t.string :file_path
    	t.string :md5
    	t.string :sha1
    	t.integer :num_evidence
    	t.text :descriptions
      t.timestamps
    end
  end
end