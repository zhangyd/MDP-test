class AddOrganizationReferenceToRepository < ActiveRecord::Migration
  def change  	
  	 add_reference :repositories, :organization, index: true
  end
end
