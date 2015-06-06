Rails.application.routes.draw do
  get 'poll(/:jobid/:nodeid)', to: 'dispatcher#poll'

  # Intruder will use the following endpoints to create and manage jobs
  post 'job/create', to: 'job#create'
end
