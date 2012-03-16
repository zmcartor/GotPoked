require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'logger'

configure do
	Log = Logger.new("debug.log")
	Log.level  = Logger::INFO
	set :port, 3333
end

#Sinatra Classic app
$config_file = ARGV[0] || 'repo_map.yml'
$configuration = YAML::load_file($config_file)

post '/poked' do
	json_push = JSON.parse params[:payload]
	local_repo = $configuration[json_push['repository']['name']]

	if local_repo.nil?
		Log.info "Sorry, no configuration for repo named #{json_push['repository']['name']}"
		halt 200
	end

	Log.info "Updating #{local_repo}"
	out = `cd #{local_repo} && git pull origin master`
	Log.info "Result of update #{out}"
	"pokeD OK"
end

get '/:r' do
	Log.info params
	#sometimes wants to grab favicon. stupid..
	pass if params[:r] == 'favicon.ico'
	local_repo = $configuration[params[:r]]
	Log.info "Updating #{local_repo}"
	out = `cd #{local_repo} && git pull origin master`
	Log.info "result of update: #{out}"
end
