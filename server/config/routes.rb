Rails.application.routes.draw do
  root to: "job#index"

  devise_for :users 

	namespace 'api' do
	  get 'health', 														to: 'health#index'
	  get 'poll(/:nodeid(/:jobid))', 						to: 'dispatcher#poll'
	  get 'checkin/:nodeid/:jobid/:status_code',to: 'dispatcher#checkin'

	  # Intruder will use the following endpoints to create and manage jobs
	  post 'job/create', 												to: 'job#create'

	  post 'job/:jobid/saveResponse', to: 'job_response#create'
	end

	get 'jobs', 									to: 'job#index', as: 'jobs'
	get	'job/:jobid',							to: 'job#show', as: 'show_job'
	get 'jobs/new', 							to: 'job#new'
	post 'jobs', 									to: 'job#create'
	get 'nodes', 									to: 'node#index'
	delete 'job/:jobid', 					to: 'job#destroy', as: 'job'

	get 'dictionaries',						to: 'dictionary#index'
	get 'dictionaries/new',				to: 'dictionary#new'
	post 'dictionaries',					to: 'dictionary#create'

	get 'users',									to: 'user#index', as: 'users'
	get 'user/:userid',						to: 'user#show', as: 'show_user'
	get 'users/new',							to: 'user#new'
	post 'users',									to: 'user#create'
	get 'users/edit/:userid',			to: 'user#edit',	as: 'edit_user'
	patch 'users/:userid',				to: 'user#update', as: 'user'
end
