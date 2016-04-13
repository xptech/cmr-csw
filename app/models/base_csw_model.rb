class BaseCswModel

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Supported output schemas
  OUTPUT_SCHEMAS = %w(http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi)
  # Supported response elements
  RESPONSE_ELEMENTS = %w(brief, summary, full)

  @request_params
  @request
  @request_body

  def initialize params, request
    @request_params = params
    @request = request
    @request_body = request.body.read
  end

end