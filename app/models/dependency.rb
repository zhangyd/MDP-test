class Dependency < ActiveRecord::Base
	has_many :vulnerabilities
end