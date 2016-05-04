class GetRecords < BaseCswModel
  RESULT_TYPES = %w(results hits)
  HTTP_METHODS = %w(Post)
  RESPONSE_ELEMENTS = %w(brief summary full)
  OUTPUT_SCHEMAS = %w(http://www.opengis.net/cat/csw/2.0.2 http://www.isotc211.org/2005/gmi)
  TYPE_NAMES = %w(csw:Record gmi:MI_Metadata)

  attr_accessor :result_types

  validate :validate_method

  attr_accessor :result_type
  validates :result_type, inclusion: {in: RESULT_TYPES, message: "Result type '%{value}' is not supported. Supported result types are results, hits"}

  attr_accessor :start_position
  validates :start_position, numericality: {only_integer: true, greater_than_or_equal_to: 1, message: 'maxRecords is not a positive integer greater than zero'}

  attr_accessor :max_records
  validates :max_records, numericality: {only_integer: true, greater_than_or_equal_to: 0, message: 'maxRecords is not a positive integer'}

  attr_accessor :response_element
  validates :response_element, inclusion: {in: RESPONSE_ELEMENTS, message: "Element set name '%{value}' is not supported. Supported element set names are brief, summary, full"}

  attr_accessor :output_schema
  validates :output_schema, inclusion: {in: OUTPUT_SCHEMAS, message: "Output schema '%{value}' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi"}

  @request_body_xml
  @filter
  @result_type
  @start_position
  @max_records
  # for now it only supports the AND between ALL CMR query parameters
  @cmr_query_hash

  def initialize(params, request)
    super(params, request)

    @cmr_query_hash = Hash.new

    if (!@request_body.empty? && @request.post?)
      @request_body_xml = Nokogiri::XML(@request_body) { |config| config.strict }

      output_schema_value = @request_body_xml.root['outputSchema']
      @output_schema = output_schema_value.blank? ? 'http://www.isotc211.org/2005/gmi' : output_schema_value
      # defaults to 'hits' (per spec)
      result_type_value = @request_body_xml.root['resultType']
      @result_type = (result_type_value.blank? || RESULT_TYPES.include?(result_type_value) == false) ? 'hits' : result_type_value

      # defaults to 'brief' (per spec)
      element_set_name_value = @request_body_xml.at_xpath('//csw:GetRecords//csw:Query//csw:ElementSetName',
                                                          'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
      @response_element = element_set_name_value.blank? ? 'brief' : element_set_name_value.text

      start_position_value = @request_body_xml.root['startPosition']
      # defaults to 1 (per spec)
      @start_position = start_position_value.blank? ? '1' : start_position_value

      max_records_value = @request_body_xml.root['maxRecords']
      # defaults to 10 (per spec)
      @max_records = max_records_value.blank? ? '10' : max_records_value

      @output_file_format = @request_body_xml.root['outputFormat'].blank? ? 'application/xml' : @request_body_xml.root['outputFormat']
      @service = @request_body_xml.root['service']
      @version = @request_body_xml.root['version']

      # Process the filter
      #TODO add support of various queryables and filter criteria in csw:Query element
      @filter = @request_body_xml.at_xpath('//csw:GetRecords//csw:Query//csw:Constraint//ogc:Filter',
                                           'csw' => 'http://www.opengis.net/cat/csw/2.0.2',
                                           'ogc' => 'http://www.opengis.net/ogc')
      if @filter != nil
        Rails.logger.info("Processing filter in GetRecords POST request:  #{@request_body}")
        filter = OgcFilter.new(@filter, @cmr_query_hash)
        filter.process_all_queryables
      else
        Rails.logger.info("No results filtering criteria specified in GetRecords POST request:  #{@request_body}")
      end

    else
      # The salient point we want to communicate is the GET error so let's initialize the rest
      @output_schema = 'http://www.isotc211.org/2005/gmi'
      @response_element = 'brief'
      @start_position = '1'
      @max_records = '10'
      @result_type = 'hits'
      @output_file_format = 'application/xml'
      @service = 'CSW'
      @version = '2.0.2'
    end
  end

  def find
    #cmr_params = to_cmr_collection_params
    Rails.logger.info "CMR Params: #{@cmr_query_hash}"
    response = nil
    begin
      time = Benchmark.realtime do
        query_url = "#{Rails.configuration.cmr_search_endpoint}/collections"
        Rails.logger.info "RestClient call to CMR endpoint: #{query_url}?#{@cmr_query_hash.to_query}"
        response = RestClient::Request.execute :method => :get, :url => "#{query_url}?#{@cmr_query_hash.to_query}",
                                               :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
                                               :headers => {:client_id => Rails.configuration.client_id,
                                                            :accept => 'application/iso19115+xml'}
      end
      Rails.logger.info "CMR dataset search took : #{time.to_f.round(2)} seconds"
    rescue RestClient::Exception => e
      Rails.logger.error("CMR call failure httpStatus: #{e.http_code} message: #{e.message} response: #{e.response}")
      # TODO add error handling
      throw OwsException.new(INVALID_REQUEST_TYPE_GET_RECORDS, 'GetRecords only supports POST requests', 'CMR CSW:GetRecords.is_valid', 400)
    end

    document = Nokogiri::XML(response)
    # This model is an array of collections in the iso19115 format. It's up to the view to figure out how to render it
    # Each gmi:MI_Metadata element is a collection
    model = OpenStruct.new
    # didn't convert to UTC Time.now.utc.iso8601
    model.server_timestamp = Time.now.iso8601
    model.output_schema = @output_schema
    model.response_element = @response_element
    model.result_type = @result_type
    model.number_of_records_matched = document.at_xpath('/results/hits').text.to_i
    # will include as a comment in the csw response XML
    model.cmr_search_duration_millis = document.at_xpath('/results/took').text.to_i
    result_nodes = document.root.xpath('/results/result')
    model.number_of_records_returned = result_nodes.blank? ? 0 : result_nodes.size
    #TODO handle edge conditions better, wait for CMR navigation by index functionality
    if (model.number_of_records_matched > model.number_of_records_returned)
      model.next_record = 1 + model.number_of_records_returned
    else
      # indicates that ALL records have been returned
      model.next_record = 0
    end
    model.raw_collections_doc = document
    return model
  end

  def to_cmr_collection_params
    cmr_params = {}

    cmr_params
  end

  private

  def validate_method
    if (@request_body.empty? || !@request.post?)
      errors.add(:method, 'Only the POST method is supported for GetRecords')
    end
  end

end