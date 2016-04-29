require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do

	describe "show" do
		it "assings correct organization to @organization by id" do
			org = Organization.create!(name: 'test org')
			get :show, id: org.id
			require 'pry'; binding.pry
		end
	end

end
