require 'spec_helper'

# describe "test" do 
# 	it "should be equal" do
# 		a = 1
# 		a.should == 1
# 	end
# end
describe RepositoriesController, :type => :controller do

	describe "GET index" do
		before(:each) do
			@repository = Repository.create(url: "hey", owner: "jt", email: "hayterji@umich.edu")
		end

		it "has a 200 status code" do
			get :index
			expect(response.status).to eq(200)			
		end

	 	it "should return all repositories" do	
	 		get :index, :format => :json
	 		binding.pry
			expect(response.body).to eq([@repository])
	 		
		end
	end

	describe "POST create" do 
		
end
