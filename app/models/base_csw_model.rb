class BaseCswModel
  #TODO refactor ALL common CSW models behavior here
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Supported outputSchema values
  OUTPUT_SCHEMAS = %w(http://www.opengis.net/cat/csw/2.0.2 http://www.isotc211.org/2005/gmi)
  # Supported ElementSetName values TODO add support for 'browse' later
  RESPONSE_ELEMENTS = %w(brief summary full)
  # Supported resultType values
  RESULT_TYPES = %w(hits, results)
  # Supported output file formats
  OUTPUT_FILE_FORMATS = %w(application/xml)

  @request_params
  @request
  @request_body

  attr_accessor :output_schema
  validates :output_schema, inclusion: {in: OUTPUT_SCHEMAS, message: "Output schema '%{value}' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi"}

  attr_accessor :output_file_format
  validates :output_file_format, inclusion: {in: OUTPUT_FILE_FORMATS, message: "Output file format '%{value}' is not supported. Supported output file format is application/xml"}

  attr_accessor :response_element
  validates :response_element, inclusion: {in: RESPONSE_ELEMENTS, message: "Element set name '%{value}' is not supported. Supported element set names are brief, summary, full"}

  attr_accessor :version
  validates :version, inclusion: {in: %w(2.0.2), message: "version '%{value}' is not supported. Supported version is '2.0.2'"}

  attr_accessor :service
  validates :service, inclusion: {in: %w(CSW), message: "service '%{value}' is not supported. Supported service is 'CSW'"}

  def initialize params, request
    @request_params = params
    @request = request
    @request_body = request.body.read
  end

end