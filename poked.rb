require 'sinatra'
require 'json'
require 'yaml'
require 'logger'

configure do
	enable :logging
	Log = Logger.new("debug.log")
	Log.level  = Logger::INFO
end

#Sinatra Classic app
$config_file = ARGV[0] || 'repo_map.yml'
$configuration = YAML::load_file($config_file)

post '/poked' do
	json_push = JSON.parse params[:payload]
	local_repo = $configuration[json_push['repository']['name']]
	Log.info params
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
