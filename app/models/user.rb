class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_and_belongs_to_many :organizations, :join_table => :users_organizations
  has_many :repositories, through: :organizations

  after_create :setup_organization

  def setup_organization
		organization = Organization.new
		organization.name = "Default Organization"
		organization.save
		self.organizations << organization
  end

end
