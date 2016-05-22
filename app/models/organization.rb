class Organization < ActiveRecord::Base
	has_many :repositories, :dependent => :destroy
	has_and_belongs_to_many :users, :join_table => :users_organizations
end
