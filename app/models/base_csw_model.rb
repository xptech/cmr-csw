class BaseCswModel
  #TODO refactor ALL common CSW models behavior here
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Supported output file formats
  OUTPUT_FILE_FORMATS = %w(application/xml)
  HTTP_METHODS = %w{Get Post}
  OUTPUT_SCHEMAS = %w(http://www.opengis.net/cat/csw/2.0.2 http://www.isotc211.org/2005/gmi http://www.isotc211.org/2005/gmd)
  TYPE_NAMES = %w(csw:Record gmi:MI_Metadata gmd:MD_Metadata)

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

  def add_cwic_parameter(params)
    #params[:include_tags] = 'org.ceos.wgiss.cwic.granules.prod'
    params
  end

  def self.add_cwic_keywords(document)
    # For each result with a CWIC tag. If it exists insert a gmd:keyword as follows,
    document.xpath('/results/result/tags/tag/tagKey').each do |tag|
      if tag.xpath("text()='org.ceos.wgiss.cwic.granules.prod'") == true
        result = tag.xpath('../../..')
        keywords = result.xpath('gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords', 'gmd' => 'http://www.isotc211.org/2005/gmd', 'gmi' => 'http://www.isotc211.org/2005/gmi', 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')
        keyword = Nokogiri::XML::Node.new 'gmd:keyword', document
        text = Nokogiri::XML::Node.new 'gco:CharacterString', document
        text.content = 'CWIC > CEOS WGISS Integrated Catalog'
        keyword.add_child text
        keywords.first.prepend_child keyword
      end
    end
    document
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