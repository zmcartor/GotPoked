require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'logger'
#Sinatra Classic app

#probably want to change this for your setup
Key = "blargh"

configure do
	Log = Logger.new("debug.log")
	Log.level  = Logger::INFO
	set :port, 3333
end

#re-read the repo from repo_map.yml each time.
#allows us to change the file without having to restart sinatra.
def find_repo_path (repo_from_github)
	config = YAML::load_file('repo_map.yml')
	config[repo_from_github]
end

post '/poked/:key' do
	halt "sorry" unless params[:key] == Key

	json_push = JSON.parse params[:payload]
	local_repo = find_repo_path json_push['repository']['name']

	if local_repo.nil?
		Log.info "Sorry, no configuration for repo named #{json_push['repository']['name']}"
		halt 200
	end

	Log.info "Updating #{local_repo}"
	out = `cd #{local_repo} && git pull origin master`
	Log.info "Result of update #{out}"
	"pokeD OK"
end
