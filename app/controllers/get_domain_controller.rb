class GetDomainController < ApplicationController

  def index
    begin
      @model = GetDomain.new(params, request)
      if @model.valid?
        @model.process_domain
        render 'get_domain/index.xml.erb', :status => :ok and return
      else
        @exceptions = []
        @model.errors.each do |attribute, error|
          @exceptions.append OwsException.new(attribute, error)
        end
        render 'shared/exception_report.xml.erb', :status => :bad_request and return
      end
    rescue OwsException => e
      # exception not captured via the ActiveModel:Validation framework
      @exceptions = []
      @exceptions.append e
      render 'shared/exception_report.xml.erb', :status => :bad_request and return
    end
  end
end
