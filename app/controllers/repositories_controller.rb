#NOTE: temp place. this is not the way to require lib!
require "nokogiri"
require "open-uri"
require "Rugged"


class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    @repository = Repository.new(repository_params)

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render :show, status: :created, location: @repository }
      else
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url, notice: 'Repository was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit( :name, :owner, :url, :email, :last_checked, :local_path)
    end

    #
    def scan
      if @repository.local_path == nil
        @repository.local_path = get_path()
        Rugged::Repository.clone_at(@repository.url, @repository.local_path)
      end
      repo_path = @repository.local_path
      report_path = "#{repo_path}/report.xml"
      cmd = "dependency-check --project #{@repository.name} -f XML --out #{report_path} --scan #{repo_path}"
      system cmd
      
      # call to import_report, which store xml report as parameter
      # 
    end

    #
    def import_report(report_path)
      report_xml = Nokogiri::XML(open(repo_path))
      #need to store this to db
      #decide to store each tag as attribute / store whole xml as string and search later.
    end
end
