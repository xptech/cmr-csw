class GetCapabilitiesController < ApplicationController
  def index
    gc = GetCapability.new params
    @get_capabilities_model = gc.get_model
    render 'get_capabilities/index.xml.erb', :status => :ok and return
  end
end
