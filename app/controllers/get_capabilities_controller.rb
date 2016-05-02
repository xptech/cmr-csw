class GetCapabilitiesController < ApplicationController

  def index
    gc = GetCapability.new(params, request)
    @get_capabilities_model = gc.get_model
    if gc.valid?
      render 'get_capabilities/index.xml.erb', :status => :ok and return
    else
      @exceptions = []
      gc.errors.each do |attribute, error|
        @exceptions.append OwsException.new(attribute, error)
      end
      render 'shared/exception_report.xml.erb', :status => :bad_request and return
    end
  end
end

