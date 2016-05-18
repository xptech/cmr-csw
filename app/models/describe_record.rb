class DescribeRecord < BaseCswModel

  attr_accessor :output_schema
  validates :output_schema, inclusion: {in: OUTPUT_SCHEMAS, message: "Output schema '%{value}' is not supported. Supported output schemas are http://www.opengis.net/cat/csw/2.0.2, http://www.isotc211.org/2005/gmi, http://www.isotc211.org/2005/gmd"}

  attr_accessor :type_names
  validate :validate_type_names

  attr_accessor :schema_language
  validates :schema_language, inclusion: {in: %w{http://www.w3.org/2001/XMLSchema XMLSCHEMA}, message: "Schema Language '%{value}' is not supported. Supported output file format is http://www.w3.org/2001/XMLSchema, XMLSCHEMA"}

  attr_accessor :namespaces
  validate :validate_namespaces

  validate :validate_method

  def initialize (params, request)
    super(params, request)

    if (@request.get?)
      @output_schema = params[:outputSchema].blank? ? 'http://www.isotc211.org/2005/gmi' : params[:outputSchema]
      @output_file_format = params[:outputFormat].blank? ? 'application/xml' : params[:outputFormat]
      @schema_language = params[:schemaLanguage].blank? ? 'XMLSCHEMA' : params[:schemaLanguage]
      @namespaces = to_output_schemas(params[:NAMESPACE])
      @type_names = params[:typeName].blank? ? [] : params[:typeName].split(',')
      @version = params[:version]
      @service = params[:service]
    elsif !@request_body.empty? && @request.post?
      # The salient point we want to communicate is the POST error so let's initialize the rest
      @output_schema = 'http://www.isotc211.org/2005/gmi'
      @output_file_format = 'application/xml'
      @type_names = []
      @schema_language = 'XMLSCHEMA'
      @namespaces = {:gmi => 'http://www.isotc211.org/2005/gmi'}
      @service = 'CSW'
      @version = '2.0.2'
    end
  end

  def get_model
    model = OpenStruct.new
    model.schemas = []
    @namespaces.each_pair do |key, value|
      schema = OpenStruct.new
      schema.namespace = value
      # Switch on namespace
      file = nil
      case value
        when 'http://www.opengis.net/cat/csw/2.0.2'
          file = File.open('app/models/schemas/csw_record.xsd', 'rb')
        when 'http://www.isotc211.org/2005/gmi'
          file = File.open('app/models/schemas/gmi_record.xsd', 'rb')
        when 'http://www.isotc211.org/2005/gmd'
          file = File.open('app/models/schemas/gmd_record.xsd', 'rb')
      end
      unless file.nil?
        schema.content = file.read
        model.schemas << schema
      end
    end
    model
  end

  private

  #def validate_type_names
  #  if @type_names.blank?
  #    errors.add(:type_names, "typeName can't be blank")
  #  else
  #    @type_names.each do |type_name|
  #      errors.add(:type_names, "#{type_name} is not one of #{TYPE_NAMES.join(', ')}") unless TYPE_NAMES.include? type_name
  #    end
  #  end
  #end

  def validate_namespaces
    @namespaces.each_pair do |key, value|
      errors.add(:namespaces, "Namespace '#{value}' is not supported. Supported namespaces are #{OUTPUT_SCHEMAS.join(', ')}") unless OUTPUT_SCHEMAS.include? value
    end
  end

  def validate_method
    if !@request.get?
      errors.add(:method, "Method 'POST' method is not supported. Supported methods for DescribeRecord are GET")
    end
  end

  def validate_type_names
    # We only support the root type names and the prefix must also match one of the namespaces given in the request
    @type_names.each do |type_name|
      # Get the prefix
      prefix = nil
      if type_name.include? ':'
        prefix = type_name.split(':')[0]
        element = type_name.split(':')[1]
      else
        element = type_name
      end
      # Is the prefix one of the ones in the namespaces?
      unless @namespaces.has_key? prefix.to_sym
        errors.add(:type_names, "Prefix '#{prefix}' does not map to any of the supplied namespaces")
      else
        href = @namespaces[prefix.to_sym]
        # Is the type one we can service?
        case element
          when 'Record'
            errors.add(:type_names, "'Record' is not part of the #{href} schema") unless href == 'http://www.opengis.net/cat/csw/2.0.2'
          when 'MI_Metadata'
            errors.add(:type_names, "'MI_Metadata' is not part of the #{href} schema") unless href == 'http://www.isotc211.org/2005/gmi'
          when 'MD_Metadata'
            errors.add(:type_names, "'MD_Metadata' is not part of the #{href} schema") unless href == 'http://www.isotc211.org/2005/gmd'
          else
            errors.add(:type_names, "'#{element}' is not a supported element for description. Supported elements are 'csw:Record', 'gmi:MI_Metadata' and 'gmd:MD_Metadata'")
        end
      end
    end
  end

  # xmlns(gml=http://www.opengis.org/gml),xmlns(wfs=http:// www.opengis.org/wfs)
  def to_output_schemas(namespaces)
    schemas = {}
    unless namespaces.blank?
      namespaces.gsub!('),xmlns(', ',')
      namespaces.gsub!('xmlns(', '')
      namespaces.chop!
      ns = namespaces.split(',')

      ns.each do |n|
        if n.include? '='
          prefix = n.split('=')[0]
          href = n.split('=')[1]
          schemas[prefix.to_sym] = href
        else
          prefix = 'default'
          href = n
          schemas[prefix.to_sym] = href
        end
      end
    else
      schemas[:gmi] = 'http://www.isotc211.org/2005/gmi'
    end
    schemas
  end

end
