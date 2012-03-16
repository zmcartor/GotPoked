require 'sinatra'
require 'json'
require 'yaml'

#Sinatra Classic app
$config_file = ARGV[0] || 'repo_map.yml'
$configuration = YAML::load_file($config_file)

post '/poked' do
	json_push = JSON.parse params[:payload]
	local_repo = $configuration[json_push['repository']['name']]
	#run shell command on server..
	puts "Updating #{local_repo}"
	`cd #{local_repo} && git pull origin master`
	"pokeD OK"
end

before '/:r' do
		puts "GOT THIS"
	p params
end

get '/:r' do
	#sometimes wants to grab favicon. stupid..
	pass if params[:r] == 'favicon.ico'
	local_repo = $configuration[params[:r]]
	p local_repo
	out = `cd #{local_repo} && git pull origin master`
	p out
end
