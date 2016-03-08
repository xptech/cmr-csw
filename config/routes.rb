require 'routes_helper'

Rails.application.routes.draw do

  root 'welcome#index'

  # user Rails 4 Advanced Constraints specification with lambda to set up the CSW routes
  # see lib/routes_helper.rb for the RequestPostRouter
  get '/', to: 'describe_record#index', constraints: lambda { |request| request.params[:request].upcase == 'DESCRIBERECORD' }
  # GetCapabilities must be supported for both GET and POST
  get '/', to: 'get_capabilities#index', constraints: lambda { |request| request.params[:request].upcase == "GETCAPABILITIES" }
  post '/', to: 'get_capabilities#index', constraints: lambda { |request| RequestPostRouter.is_get_capabilities(request.body) }
  get '/', to: 'get_domain#index', constraints: lambda { |request| request.params[:request].upcase == "GETDOMAIN" }
  post '/', to: 'get_record_by_id#index', constraints: lambda { |request| RequestPostRouter.is_get_record_by_id(request.body) }
  post '/', to: 'get_records#index', constraints: lambda { |request| RequestPostRouter.is_get_records(request.body) }

  get 'health/index'
  get 'health' => 'health#index', format: 'json'

end
