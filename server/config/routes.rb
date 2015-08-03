Rails.application.routes.draw do
	namespace 'api' do
	  get 'health', 														to: 'health#index'
	  get 'poll(/:nodeid(/:jobid))', 						to: 'dispatcher#poll'
	  get 'checkin/:nodeid/:jobid/:status_code',to: 'dispatcher#checkin'

	  # Intruder will use the following endpoints to create and manage jobs
	  post 'job/create', 												to: 'job#create'

	  post 'job/:jobid/saveResponse', to: 'job_response#create'
	end

	get 'jobs', 									to: 'job#index'
	get	'job/:jobid',							to: 'job#show'
	get 'jobs/new', 							to: 'job#new'
	post 'jobs', 									to: 'job#create'
	get 'nodes', 									to: 'node#index'
	delete 'job/:jobid', 					to: 'job#destroy', as: 'job'

	get 'dictionaries',						to: 'dictionary#index'
	get 'dictionaries/new',				to: 'dictionary#new'
	post 'dictionaries',					to: 'dictionary#create'
end
