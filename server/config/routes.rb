Rails.application.routes.draw do
	namespace 'api' do
	  get 'health', 			to: 'health#index'
	  get 'poll(/:nodeid(/:jobid))', to: 'dispatcher#poll'

	  # Intruder will use the following endpoints to create and manage jobs
	  post 'job/create', to: 'job#create'

	  get 'test', to: 'dispatcher#test'
	end

	get 'jobs', to: 'job#index'
	get 'jobs/new', 	to: 'job#new'
	post 'jobs', to: 'job#create'
	get 'nodes', to: 'node#index'
	delete 'job/:jobid', to: 'job#destroy', as: 'job'
end
