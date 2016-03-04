class CswController < ApplicationController
  def route
    # I can't think of a better way to model the non-RESTful format that CSW uses.
    # 1. Switch on request type
    # 2. Generate model from parameters and CMR search (in most cases)
    # 3. Populate xml template from model
    if params[:request] == 'GetCapabilities'
      gc = GetCapability.new params
      @get_capabilities_model = gc.get_model
      render 'csw/get_capabilities.xml.erb', :status => :ok and return
    else
      # If we do not have any CSW parameters then we should render the documentation page unless there is a viable erroring out case to be resolved
      render 'welcome/index.html.erb', :status => :ok and return
    end
  end
end
