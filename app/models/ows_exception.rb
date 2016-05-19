class OwsException < StandardError
  attr_reader :text
  attr_reader :code
  attr_reader :locator

  def initialize(attribute, error)
    @text = error
    # To add: OperationNotSupported, ResourceNotFound
    if error.include?('supported')
      @code = 'InvalidParameterValue'
    elsif error.include?('blank')
      @code = 'MissingParameterValue'
    else
      @code = 'NoApplicableCode'
    end

    # Map our query attribute to CSW attribute
    attribute = attribute.to_s
    if attribute == 'output_schema'
      attribute = 'outputSchema'
    elsif attribute == 'response_element'
      attribute = 'ElementSetName'
    elsif attribute == 'output_file_format'
      attribute = 'outputFormat'
    elsif attribute == 'type_names'
      attribute = 'typeName'
    elsif attribute == 'schema_language'
      attribute = 'schemaLanguage'
    elsif attribute == 'namespaces'
      attribute = 'NAMESPACE'
    end
    @locator = attribute
  end
end
