require 'routes_helper'

Rails.application.routes.draw do

  root 'welcome#index'

  # user Rails 4 Advanced Constraints specification with lambda to set up the CSW routes
  get '/', to: 'describe_record#index', constraints: lambda { |request| request.params[:request].upcase == 'DESCRIBERECORD' }
  get '/', to: 'get_capabilities#index', constraints: lambda { |request| request.params[:request].upcase == "GETCAPABILITIES" }
  get '/', to: 'get_domain#index', constraints: lambda { |request| request.params[:request].upcase == "GETDOMAIN" }
  post '/', to: 'get_record_by_id#index', constraints: lambda { |request| RequestPostRouter.is_get_record_by_id(request.body) }
  post '/', to: 'get_records#index', constraints: lambda { |request| RequestPostRouter.is_get_records(request.body) }

  get 'health/index'
  get 'health' => 'health#index', format: 'json'

end
