class GetCapabilitiesController < ApplicationController

  def index
    gc = GetCapability.new(params, request)
    @get_capabilities_model = gc.get_model
    begin
      if gc.is_valid()
        render 'get_capabilities/index.xml.erb', :status => :ok and return
      end
    # TODO might want to rescue ALL exceptions not just OwsException
    rescue OwsException => e
        render xml: e.to_xml, :status => e.http_code and return
    end
  end

end
