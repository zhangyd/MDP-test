class Report < ActiveRecord::Base
	belongs_to :repository
	has_many :dependencies
	has_many :vulnerabilities, through: :dependencies
end
