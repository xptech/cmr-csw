class GetRecordById

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Supported output schemas
  OUTPUT_SCHEMAS = %w(http://www.opengis.net/cat/csw/2.0.2 http://www.isotc211.org/2005/gmi)
  # Supported response elements
  RESPONSE_ELEMENTS = %w(brief summary full)

  @request_params
  @request
  @request_body


  attr_accessor :id
  validates :id, presence: {message: 'id can\'t be blank'}

  attr_accessor :output_schema
  validates :output_schema, inclusion: {in: OUTPUT_SCHEMAS, message: "Output schema '%{value}' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi"}

  attr_accessor :response_element
  validates :response_element, inclusion: {in: RESPONSE_ELEMENTS, message: "Element set name '%{value}' is not supported. Supported element set names are brief, summary, full"}

  # These validations should eventually go in a parent request class
  attr_accessor :version
  validates :version, inclusion: {in: %w(2.0.2), message: "version '%{value}' is not supported. Supported version is '2.0.2'"}

  attr_accessor :service
  validates :service, inclusion: {in: %w(CSW), message: "service '%{value}' is not supported. Supported service is 'CSW'"}

  def initialize (params, request)
    @request_params = params
    @request = request
    @request_body = request.body.read

    if (@request.get?)
      @output_schema = params[:outputSchema].blank? ? 'http://www.isotc211.org/2005/gmi' : params[:outputSchema]
      @response_element = params[:ElementSetName].blank? ? 'summary' : params[:ElementSetName]
      @id = params[:id]
      @version = params[:version]
      @service = params[:service]
    end
    # Post in later sprint
  end

  def submit
    cmr_params = to_cmr_collection_params
    Rails.logger.info "CMR Params: #{cmr_params}"
    response = nil
    begin
      time = Benchmark.realtime do
        query_url = "#{Rails.configuration.cmr_search_endpoint}/collections"
        Rails.logger.info "RestClient call to CMR endpoint: #{query_url}?#{cmr_params.to_query}"
        # RestClient does not support array parameters in a query so we have to inline them in the url parameter. Which sucks...
        response = RestClient::Request.execute :method => :get, :url => "#{query_url}?#{cmr_params.to_query}", :verify_ssl => OpenSSL::SSL::VERIFY_NONE, :headers => {:client_id => Rails.configuration.client_id, :accept => 'application/iso19115+xml'}
      end
      Rails.logger.info "CMR dataset search took : #{time.to_f.round(2)} seconds"
    rescue RestClient::BadRequest => e
      # An unknown concept id will give a bad request error
      response = e.response if e.response.include?('Concept-id') && e.response.include?('is not valid')
    end

    document = Nokogiri::XML(response)
    # This model is an array of collections in the iso19115 format. It's up to the view to figure out how to render it
    # Each gmi:MI_Metadata element is a collection
    model = OpenStruct.new
    model.output_schema = @output_schema
    model.response_element = @response_element
    model.collections = document.root.xpath('/results', 'gmi' => 'http://www.isotc211.org/2005/gmi').to_xml
    model
  end

  private

  # I'd like to use the validation framework to achieve this
  def validate_post_request
    Rails.logger.info('Validating GetRecords POST request')
    exception_message = nil
    begin
      request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }
      root_name = request_body_xml.root.name
      service_attribute = request_body_xml.root['service']
      version_attribute = request_body_xml.root['version']
      if service_attribute == nil || service_attribute.upcase != 'CSW'
        exception_message = "The CSW GetRecords POST request must contain the 'service=CSW' attribute for the 'GetRecords' root element."
      end
      if root_name.upcase != 'GETRECORDS'
        if (exception_message != nil)
          exception_message = exception_message + "The CSW GetRecords POST request must contain the 'GetRecords' root element."
        else
          exception_message = "The CSW GetRecords POST request must contain the 'GetRecords' root element."
        end
      end
      if version_attribute == nil || version_attribute != '2.0.2'
        if (exception_message != nil)
          exception_message = exception_message + "The CMR CSW 'GetRecords' POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element."
        else
          exception_message = "The CMR CSW GetRecords POST request must contain the 'version=2.0.2' attribute for the 'GetRecords' root element."
        end
      end
      if (exception_message == nil)
        return true
      else
        ex = OwsException.new(INVALID_POST_REQUEST_GET_RECORDS, exception_message, 'CMR CSW:GetRecords.validate_post_request', 400)
        raise ex
      end
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error("Invalid XML in POST request body:  #{@request_body}")
      ex = OwsException.new(INVALID_POST_REQUEST_GET_RECORDS, " #{e.inspect}", "CMR CSW:GetRecords.validate_post_request", 400)
      raise ex
    end
    return false
  end

  private

  def to_cmr_collection_params
    cmr_params = {}
    id_array = []
    # The Id parameter is a comma-separated list of concept ids. This needs to converted into a repeated number of concept_id parameters
    # For example,
    # Id=C1224520098-NOAA_NCEI,C1224520058-NOAA_NCEI
    # becomes
    # concept_id[]=C1224520098-NOAA_NCEI&concept_id[]=C1224520058-NOAA_NCEI
    unless @id.blank?
      @id.split(',').each do |id|
        id_array.append id
      end
    end
    cmr_params[:concept_id] = id_array
    cmr_params
  end
end
