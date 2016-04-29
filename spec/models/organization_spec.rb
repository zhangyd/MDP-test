require 'rails_helper'

RSpec.describe Organization, type: :model do
  it "can create instance of Organization" do
  	org = Organization.create!(name: 'some org')

  	expect(org.name).to eq('some org')
  end
end
