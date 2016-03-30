# require "util"
require "rubygems"
require "nokogiri"
require "Rugged"
require "digest/murmurhash"

class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy, :scan]

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

  # **********************************************************************************

  def scan
    repo_id = Repository.find(params[:id]).id
    repo_name = Repository.find(params[:id]).name
    # user_name = Repository.find(params[:id]).owner
    url = Repository.find(params[:id]).url
    userpath = Repository.find(params[:id]).userpath
    repopath = Repository.find(params[:id]).repopath
    # Pull repository if not pulled yet
    if !(File.directory?(repopath)) then
      @repo = Rugged::Repository.clone_at(url, repopath)
    end
    # Insert into Report table 
    t = Time.new
    report_path = userpath + '/report'
    report_name = "#{report_path}/#{t.strftime('%Y%m%d_%H%M%S')}.xml"
    @report = Report.new(:repo_id => repo_id, :filename => report_name)
    @report.save
    # Run Dependency Check
    cmd = "dependency-check --app #{repo_name} --format XML --out #{report_name} --scan #{repopath}"
    system cmd

  end

  def scanselected

    puts "THIS PRINTED"

    repos = params[:repos]

    repos.each do |repo|
      name = Repository.find(repo.to_i).name
      owner = Repository.find(repo.to_i).owner
      url = Repository.find(repo.to_i).url

      repo_id = Repository.find(repo.to_i).id
      repo_name = Repository.find(repo.to_i).name
      # user_name = Repository.find(params[:id]).owner
      url = Repository.find(repo.to_i).url
      userpath = Repository.find(repo.to_i).userpath
      repopath = Repository.find(repo.to_i).repopath
      # Pull repository if not pulled yet
      if !(File.directory?(repopath)) then
        @repo = Rugged::Repository.clone_at(url, repopath)
      end
      # Insert into Report table 
      t = Time.new
      report_path = userpath + '/report'
      report_name = "#{report_path}/#{t.strftime('%Y%m%d_%H%M%S')}.xml"
      @report = Report.new(:repo_id => repo_id, :filename => report_name)
      @report.save
      # Run Dependency Check
      cmd = "dependency-check --app #{repo_name} --format XML --out #{report_name} --scan #{repopath}"
      system cmd
    end 

    redirect_to root_path
  end


  # **********************************************************************************

  # POST /repositories
  # POST /repositories.json
  def create
    # Generate user_path
    username = params[:repository][:owner]
    user_hash = Digest::MurmurHash1.hexdigest(username)
    user_path = "#{Dir.pwd}/private/#{user_hash}"
    # Generate repo_path
    repo_name = params[:repository][:name]
    repo_hash = Digest::MurmurHash1.hexdigest(repo_name)
    repo_path = "#{user_path}/#{repo_hash}"
    # Make a folder for the user if one doesn't exist
    if !(Dir.exists?(user_path)) then
      system "mkdir #{user_path}"
      report_path = user_path + '/report'
      system "mkdir #{report_path}"
    end

    # Insert new record 
    @repository = Repository.new(repository_params.merge(:userpath => user_path, :repopath => repo_path))

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
    
    user_path = Repository.find(params[:id]).userpath

    cmd = "rm -r #{user_path}"
    system cmd


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
      params.require(:repository).permit(:name, :url, :owner, :email, :last_checked)
    end
end
