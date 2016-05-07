class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :organizations, :join_table => :users_organizations
  has_many :repositories, through: :organizations

  after_create :setup_organization

  def setup_organization
		organization = Organization.new
		organization.name = "Unnamed"
		organization.save
		self.organizations << organization
  end

end
