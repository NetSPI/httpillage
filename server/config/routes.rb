Rails.application.routes.draw do
  root to: "job#index"

  devise_for :users 

	namespace 'api' do
	  get 'health', 														to: 'health#index'
	  get 'poll(/:nodeid(/:jobid))', 						to: 'dispatcher#poll'
	  get 'checkin/:nodeid/:jobid/:status_code',to: 'dispatcher#checkin'
	  get 'charsets',														to: 'charset#index'

	  # Intruder will use the following endpoints to create and manage jobs
	  post 'job/create', 												to: 'job#create'

	  post 'job/:jobid/saveResponse', to: 'job_response#create'
	  post 'job/:jobid/saveMatch',		to: 'response_flag#create'
	  post 'job/:jobid/saveMatchBatch', to: 'response_flag#create_bulk'
	end

	get 'settings',								to: 'setting#index', as: 'settings'

	get 'jobs', 									to: 'job#index', as: 'jobs'
	get	'job/:jobid',							to: 'job#show', as: 'show_job'
	get 'jobs/new', 							to: 'job#new'
	post 'jobs', 									to: 'job#create'
	get 'job/edit/:jobid',				to: 'job#edit', as: 'edit_job'
	patch 'job/:jobid',						to: 'job#update', as: 'update_job'
	get 'job/:jobid/progress',		to: 'job#bruteforce_progress'
	get 'job/:jobid/checkins/poll/:timestamp', to: 'job#checkins_since_timestamp'

	get 'job/response/:responseid', to: 'job_response#show', as: 'show_job_response'
	get 'job/response/fromMatch/:matchId', to: 'response_flag#show', as: 'show_flagged_response'
	get 'job/response/:jobid/poll/:timestamp', to: 'response_flag#responses_since_timestamp'
	get 'job/matches/:jobid',			to: 'response_flag#index', as: 'export_job_matches'
	get 'job/statuses/:jobid',		to: 'node_status#index',	as: 'export_node_status'

	# For controlling jobs
	patch 'job/:jobid/start',			to: 'job#start', as: 'start_job'
	patch 'job/:jobid/stop',			to: 'job#stop',	as: 'stop_job'
	delete 'job/:jobid', 					to: 'job#destroy', as: 'job'

	get 'nodes', 									to: 'node#index'

	get 'dictionaries',						to: 'dictionary#index'
	get 'dictionary/:dictionaryid', to: 'dictionary#show', as: 'download_dictionary'
	get 'dictionaries/new',				to: 'dictionary#new'
	post 'dictionaries',					to: 'dictionary#create'
	delete 'dictionary/:dictionaryid', to: 'dictionary#destroy', as: 'destroy_dictionary'

	get 'charsets',						to: 'charset#index'
	get 'charset/new',				to: 'charset#new'
	post 'charsets',					to: 'charset#create'
	delete 'charset/:charsetid', to: 'charset#destroy', as: 'destroy_charset'


	get 'users',									to: 'user#index', as: 'users'
	get 'user/:userid',						to: 'user#show', as: 'show_user'
	get 'users/new',							to: 'user#new'
	post 'users',									to: 'user#create', as: 'create_user'
	get 'users/edit/:userid',			to: 'user#edit',	as: 'edit_user'
	patch 'users/:userid',				to: 'user#update', as: 'user'
	delete 'user/:userid', 				to: 'user#destroy', as: 'destroy_user'
end
