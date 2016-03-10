#!/usr/bin/ruby
require "./util.rb"

puts "Hello, please follow the commend to test out the sample demonstration of some functionality"
puts "Enter the project name"
name = gets.rstrip
puts "Enter the username of the repo"
user = gets.rstrip
puts "Enter the remote url of the target repo"
remote_url = gets.rstrip
# puts "Enter the local path where you want to store the repo (must be empty)"
# local_path = gets.rstrip
#puts "Enter the local path where you want to store the scan result(must be empty)"
#out_path = gets

r = Project.new(name, user, remote_url)


r.clone_from_remote
r.scan
#r.import_report


