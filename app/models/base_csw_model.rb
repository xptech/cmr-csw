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

  attr_accessor :output_file_format
  validates :output_file_format, inclusion: {in: OUTPUT_FILE_FORMATS, message: "Output file format '%{value}' is not supported. Supported output file format is application/xml"}

  attr_accessor :version
  validate :validate_version

  attr_accessor :service
  validate :validate_service

  def initialize(params, request)
    @request_params = params
    @request = request
    @request_body = request.body.read
  end

  private

  # We have a combination of required and controlled values for both version and service
  def validate_version
    if @version.blank?
      errors.add(:version, "version can't be blank")
    elsif @version != '2.0.2'
      errors.add(:version, "version '#{@version}' is not supported. Supported version is '2.0.2'")
    end
  end

  # We have a combination of required and controlled values for both version and service
  def validate_service
    if @service.blank?
      errors.add(:service, "service can't be blank")
    elsif @service != 'CSW'
      errors.add(:service, "service '#{@service}' is not supported. Supported service is 'CSW'")
    end
  end

end