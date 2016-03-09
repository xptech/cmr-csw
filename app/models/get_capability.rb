class GetCapability

  def initialize params, root_url

  end

  def get_model
    model = OpenStruct.new
    model.title = 'NASA\'s CMR CSW Service'
    ##model.csw_endpoint = Rails.application.routes.url_helpers.root_url

    return model
  end
end