# Accorging to the CSW specification, the only way to execute a GET without XML ecoding is via the CQL language and the
# constraint query parameter.  The XML encoding results in more complex queries and can run into URL length limitations.
#
class CqlFilter
  CONSTRAINT_LAGUAGES = %w(CQL_TEXT)

  @constraint
  @constraint_language
  @cmr_query_hash


  def initialize (constraint, constraint_language, cmr_query_hash)
    @constraint = constraint
    @constraint_language = constraint_language

    if (!@constraint.empty? && !CONSTRAINT_LAGUAGES.include?(@constraint_language))
      error_message = "GetRecords GET request error: "
      if @constraint_language.empty?
        error_message = error_message + "the CONSTRAINTLANGUAGE query parameter cannot be blank and must equal 'CQL_TEXT' when the [constraint=#{@constraint}] is specified."
      else
        error_message = error_message + "the CONSTRAINTLANGUAGE query parameter value '#{@constraint_language}' is not supported. The only supported value is CQL."
      end
      Rails.logger.error(error_message)
      raise OwsException.new('query_language', error_message)
    end
    @cmr_query_hash = cmr_query_hash
  end

  def process_constraint

  end

end