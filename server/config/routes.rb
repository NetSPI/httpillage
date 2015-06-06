Rails.application.routes.draw do
  get 'poll(/:nodeid(/:jobid))', to: 'dispatcher#poll'

  # Only temporary for testing...
  post 'poll', to: 'dispatcher#poll'

  # Intruder will use the following endpoints to create and manage jobs
  post 'job/create', to: 'job#create'
end
