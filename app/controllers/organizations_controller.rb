class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @organizations = current_user.organizations
    respond_with(@organizations)
  end

  def show
    @repositories = Repository.where(:organization_id => params[:id])
  end

  def new
    @organization = Organization.new
    respond_with(@organization)
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)
    current_user.organizations << @organization
    @organization.save
    respond_with(@organization)
  end

  def update
    @organization.update(organization_params)
    respond_with(@organization)
  end

  def destroy
    @organization.destroy
    respond_with(@organization)
  end

  private
    def set_organization
      @organization = Organization.find(params[:id])
      redirect_to root_path unless current_user.organizations.include?(@organization)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name)
    end
end
