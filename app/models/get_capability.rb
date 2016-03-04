class GetCapability

  def initialize params

  end

  def get_model
    model = OpenStruct.new
    # This just an example. In reality this would be in-lined into the template.
    model.title = 'NASA\'s CMR CSW Service'
    model
  end
end