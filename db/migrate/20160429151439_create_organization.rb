class CreateOrganization < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
    	t.string :name

    	t.timestamps
    end

    create_table :users_organizations do |t|
    	t.references :organization
    	t.references :user
    end
  end
end
