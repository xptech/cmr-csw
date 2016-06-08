require 'routes_helper'

Rails.application.routes.draw do

  # use Rails 4 Advanced Constraints specification with lambda to set up the CSW routes
  # see lib/routes_helper.rb for the RequestRouter
  get '/collections', to: 'describe_record#index', constraints: lambda { |request| RequestRouter.is_describe_record_get(request) }
  post '/collections', to: 'describe_record#index', constraints: lambda { |request| RequestRouter.is_describe_record_post(request) }
  # GetCapabilities must be supported for both GET and POST
  get '/collections', to: 'get_capabilities#index', constraints: lambda { |request| RequestRouter.is_get_capabilities_get(request) }
  post '/collections', to: 'get_capabilities#index', constraints: lambda { |request| RequestRouter.is_get_capabilities_post(request) }
  # GetDomain must be supported for both GET and POST
  get '/collections', to: 'get_domain#index', constraints: lambda { |request| RequestRouter.is_get_domain_get(request) }
  post '/collections', to: 'get_domain#index', constraints: lambda { |request| RequestRouter.is_get_domain_post(request) }
  # TBD if GetRecordById will also be supported via GET
  get '/collections', to: 'get_record_by_id#index', constraints: lambda { |request| RequestRouter.is_get_record_by_id_get(request) }
  post '/collections', to: 'get_record_by_id#index', constraints: lambda { |request| RequestRouter.is_get_record_by_id_post(request) }
  # GetRecords does not support GET but must return a meaningful exception
  post '/collections', to: 'get_records#index', constraints: lambda { |request| RequestRouter.is_get_records_post(request) }
  get '/collections', to: 'get_records#index', constraints: lambda { |request| RequestRouter.is_get_records_get(request) }
  get 'health/index'
  get 'health' => 'health#index', format: 'json'

  # MUST remain at the bottom (or below the lambdas) so that it doesn't match the get requests to root before the lambdas

  # When we add granule support we will have to start splitting this up
  get '/collections', to: 'welcome#index'
  root 'welcome#redirect'

end
