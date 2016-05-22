# require "util"
require "rubygems"
require "nokogiri"
require "Rugged"
require "digest/murmurhash"

class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy, :scan]
  before_action :authenticate_user!

  # GET /repositories
  # GET /repositories.json
  # def index
  #   @repositories = Repository.all
  # end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
  end

  # GET /repositories/new
  def new
    # We don't associate this with the user yet!
    @repository = Repository.new
    @organization = Organization.find(params[:organization_id])
  end

  # GET /repositories/1/edit
  def edit
  end

  # get correct dependencies to display in database
  def dependencies
    @report_id = Report.where(:repository_id => params[:id]).last.id # get most recent report
    @dependencies = Dependency.where(:report_id => @report_id)
    @vulnerabilities = []
    @dependencies.each do |dep|
      @vulnerabilities << Vulnerability.where(:dependency_id => dep.id)
    end

    repo = Repository.where(:id => params[:id]).last
    @email = repo.email
    @owner = repo.owner

    DeveloperMailer.security_warning(@email, @owner, @dependencies, @vulnerabilities).deliver
  end

  # **********************************************************************************

  #TODO: Fail if no repos are selected
  def scanselected
    repos = params[:repos]

    repos.each do |repo|
      repo = Repository.find(repo.to_i)
      repo_name = repo.name
      owner = repo.owner
      url = repo.url
      repo_id = repo.id

      # user_name = Repository.find(params[:id]).owner
      url = repo.url
      userpath = repo.userpath
      repopath = repo.repopath

      # Pull repository if not pulled yet
      if !(File.directory?(repopath)) then
        @repo = Rugged::Repository.clone_at(url, repopath)
      end

      # Insert into Report table
      t = Time.new
      report_path = userpath + '/report'
      report_name = "#{report_path}/#{t.strftime('%Y%m%d_%H%M%S')}.xml"
      @report = repo.reports.create(:repository_id => repo_id, :filename => report_name)
      # @report = Report.new(:repository_id => repo_id, :filename => report_name)
      # @report.save

      # Run Dependency Check
      system "mkdir #{report_path}" #HERE
      cmd = "dependency-check --app #{repo_name} --format XML -o #{report_name} --scan #{repopath}"
      system cmd

      # send email
      # DeveloperMailer.security_warning(Repository.find(repo.to_i).email).deliver

      # Store generated report information in db
      import_report(report_name, repo.email)
    end

    redirect_to root_path
  end

  def import_report(report_name, email)
    # first map all dependencies to correct report
    thisReport = Report.find_by(:filename => report_name)

    # add unique identifier to each dependency in report
    count = 0
    doc = Nokogiri::XML(open(report_name))
    doc.css('dependency').each do |node|
      depId = Nokogiri::XML::Node.new "dependency_id", doc
      depId.content = count
      node.first_element_child.before(depId)
      count += 1
    end

    # get list of dependencies
    dependency = doc.search("dependency").map do |dependency|
        %w[
            dependency_id fileName filePath md5 sha1 description
            ].each_with_object({}) do |n, o|
            o[n] = dependency.at(n)
        end
    end

    # get list of vulnerabilities
    vulnerability = doc.search("vulnerability").map do |vulnerability|
      id = vulnerability.parent.parent
      id = id.first_element_child
      %w[
    name cvssScore cvssAccessVector cvssAccessComplexity cvssAuthenticationr
    cvssConfidentialImpact cvssAvailabilityImpact severity description
      ].each_with_object({}) do |n, o|
        o[n] = vulnerability.at(n).text
        o["dependency_id"] = id.text
      end
    end

    # store dependencies and vulnerabilities
    # a vulnerability belongs to a dependency when
    # vulnerability["dependency_id"] == dependency["dependency_id"].text
    dependency.each do |dep|
      @dependency = thisReport.dependencies.create(
        :file_name => dep["fileName"].text,
        :file_path => dep["filePath"].text,
        :md5 => dep["md5"].text,
        :sha1 => dep["sha1"].text)
        # :descriptions => dep["description"].text )

      vulnerability.each do |vuln|
        if vuln["dependency_id"] == dep["dependency_id"].text
          @vulnerability = @dependency.vulnerabilities.create(
            :cve_name => vuln["name"],
            :cvss_score => vuln["cvssScore"],
            :cav => vuln["cvssAccessVector"],
            :cac => vuln["cvssAccessComplexity"],
            :ca => vuln["cvssAuthenticationr"],
            :cci => vuln["cvssConfidentialImpact"],
            :cai => vuln["cvssAvailabilityImpact"],
            :cii => vuln["cvssIntegrityImpact"],
            :severity => vuln["severity"],
            :description => vuln["description"] )
        end

      end

    end

  end # end import_report

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
    @repository.update_attribute(:organization_id, params[:organization_id])

    respond_to do |format|
      if @repository.save
        format.html { redirect_to organization_path(params[:organization_id]), notice: 'Repository was successfully created.' }
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
        format.html { redirect_to organization_path(params[:organization_id]), notice: 'Repository was successfully updated.' }
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
      # format.html { redirect_to repositories_url, notice: 'Repository was successfully destroyed.' }
      format.html { redirect_to organization_path(params[:organization_id]), notice: 'Repository was successfully destroyed.' }
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
