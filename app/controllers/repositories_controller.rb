require "util"

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
    name = Repository.find(params[:id]).name
    owner = Repository.find(params[:id]).owner
    url = Repository.find(params[:id]).url


    # if(given project doesnt exist in table ){
      r = Project.new(name, owner, url)
      # ... = r.user_path
      #     = r.repo_path
      r.clone_from_remote
    # }
    # else {
    #   # Find this r from database 
    # }
    
    r.scan

  end

  def scanselected

    puts "THIS PRINTED"

    repos = params[:repos]

    repos.each do |repo|
      name = Repository.find(repo.to_i).name
      owner = Repository.find(repo.to_i).owner
      url = Repository.find(repo.to_i).url

      r = Project.new(name, owner, url)
      r.clone_from_remote
      r.scan
    end 

    redirect_to root_path
  end


  # **********************************************************************************

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
    path = Repository.find(params[:id]).owner.to_s;
    user_hash = Digest::MurmurHash1.hexdigest(path)
    user_path = "#{Dir.pwd}/private/#{user_hash}"

    puts "CHECK THIS: " + user_path

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
      params.require(:repository).permit(:name, :url, :path, :owner, :email, :last_checked)
    end
end
