class Repository < ActiveRecord::Base
	has_many :reports
	has_many :users, through :organization
	belongs_to :organization
end
