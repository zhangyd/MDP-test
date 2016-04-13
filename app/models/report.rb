class Report < ActiveRecord::Base
	belongs_to :repository
	has_many :dependencies
end
