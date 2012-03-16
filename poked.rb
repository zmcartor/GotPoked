require 'sinatra'
require 'json'
require 'yaml'

#Sinatra Classic app

SECRET = "supercool"

configure do
	Log = Logger.new("debug.log")
	Log.level = Logger::INFO
end

before do
	puts "GOT THIS"
	p params
end

config_file = ARGV[0] || 'repo_map.yml'
configuration = YAML::load_file(config_file)

def our_local_path(remote_repo)
	configuration['repos'][remote_repo]
end

post '/:secret' do
	halt unless params[:secret].eq? SECRET
	json_push = JSON.parse(params[:payload])
	local_repo = our_local_path json_push['repository']['name']
	
	#run shell command on server..
	`cd #{local_repo} && git pull origin master`
	"pokeD OK"
end

get '/:r' do
	local_repo = our_local_path params[:r]
	Log.info "doing local repo: #{local_repo} "
	`cd #{local_repo} && git pull origin master`
end
