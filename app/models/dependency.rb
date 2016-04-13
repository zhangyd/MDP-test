class Dependency < ActiveRecord::Base
	has_many :vulnerabilities
	belongs_to :report
end