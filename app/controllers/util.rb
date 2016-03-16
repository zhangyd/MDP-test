#!/usr/bin/ruby
require "rubygems"
require "nokogiri"
require "Rugged"
require "digest/murmurhash"

#
# need a series of user input check
#

module RailsLoggerInterface
  def logger
    Rails.logger
  end
end

class Project
	#include Util
	include RailsLoggerInterface

	def initialize(_name, _user, _url_addr)
		@name = _name
		@user = _user
		@url_addr = _url_addr

		@user_path = get_user_path(@user)
		@repo_path = get_repo_path(@name, @user_path)

		@reports = Array.new()
		# set up folder for storing report
		@report_path = @user_path + '/report'
		system "mkdir #{@report_path}"

		@user_hash = Digest::MurmurHash1.hexdigest(@user)
		
		@repo_has = Digest::MurmurHash1.hexdigest(@name)
	end

	
	def clone_from_remote
		if !(File.directory?(@user_path))
			@repo = Rugged::Repository.clone_at(@url_addr, @repo_path)
		end
	end

	def scan
		t = Time.new
		report_name = "#{@report_path}/#{t.strftime('%Y%m%d_%H%M%S')}.xml"

		# puts "report_name: #{report_name}"

		cmd = "dependency-check --project #{@name} --format XML --out #{report_name} --scan #{@repo_path}"
		system cmd

		@reports.push(report_name)

		# ABBY: this wasn't working so I commented it out for now
		#check successful
		# if File.directory?(report_name)
		# 	# puts "PUSHED TO REPORTS ARRAY"
		# 	@reports.push(report_name)
		# end
	end

	def import_report
		#assume import the last generated report
		#need to add some check in future
		#TODO: THIS IS HARDCODED
		xml = Nokogiri::XML(open(@report_path+'/20160315_212343.xml'))

		dependency = xml.search('dependency').map do |dependency|
			%w[
				fileName filePath md5 sha1 description evidenceCollected identifiers vulnerabilities 
			].each_with_object({}) do |n, o|
				o[n] = dependency.at(n)
			end
		end
		#only store dependencies with vulnerabilities
		has_vulnerability = dependency.keep_if { |dep| !dep["vulnerabilities"].nil? }
		
		# store in database
		has_vulnerability.each { |x|
			puts "Filename: " + x['fileName'].inner_text + "\n"
			puts "Filepath: " + x['filePath'].inner_text + "\n"
			puts "MD5: " + x['md5'].inner_text + "\n"
			puts "sha1: " + x['sha1'].inner_text + "\n"
			puts "Description: " + x['description'].inner_text + "\n"
			puts "Evidence: " + x['evidenceCollected'].inner_text + "\n"
			puts "Identifiers: " + x['identifiers'].inner_text + "\n"
			puts "Vulnerabilities: " + x['vulnerabilities'].inner_text + "\n\n"
			# vulnerability = Vulnerability.new
			# vulnerability.fileName = x['fileName'].inner_text
			# vulnerability.filePath = x['filePath'].inner_text
			# vulnerability.md5 = x['md5'].inner_text
			# vulnerability.sha1 = x['sha1'].inner_text
			# vulnerability.description = x['description'].inner_text
			# vulnerability.evidenceCollected = x['evidenceCollected'].inner_text
			# vulnerability.identifiers = x['identifiers'].inner_text
			# vulnerability.vulnerabilities = x['vulnerabilities'].inner_text
			# vulnerability.userHash = @user_hash + @repo_hash
		}
		
	end

	def get_user_path(username)
		#add param checking
		user_hash = Digest::MurmurHash1.hexdigest(username)
		
		user_path = "#{Dir.pwd}/private/#{user_hash}"

		puts "userpath#{user_path}" #debug
		return user_path
	end

	# Design choice: hash every user + repo name to a hex string
	# to be used as local_path
	# input: 
	# output
	def get_repo_path(repo_name,user_path)
		repo_hash = Digest::MurmurHash1.hexdigest(repo_name)
		
		repo_path = "#{user_path}/#{repo_hash}"

		#repo_path = "#{user_path}/#{repo_hash}"

		puts "repo_path#{repo_path}" #debug
		return repo_path
	end
end