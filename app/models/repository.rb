class Repository < ActiveRecord::Base
	has_many :reports
	has_many :dependencies
end
