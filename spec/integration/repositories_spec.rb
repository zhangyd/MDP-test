require 'spec_helper'

# describe "test" do 
# 	it "should be equal" do
# 		a = 1
# 		a.should == 1
# 	end
# end
describe RepositoriesController, :type => :controller do
	describe "GET index" do
		it "has a 200 status code" do
			get :index
			expect(response.status).to eq(200)			
		end

	 	it "should return all repositories" do	
	 		Repository.create(url: "hey", owner: "jt", email: "hayterji@umich.edu")

	 		get :index, :format => :json
	 		binding.pry
			expect(response.status).to eq(200)
	 		
		end
	end
end
