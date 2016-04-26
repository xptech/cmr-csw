class OgcFilterAnyText
  @@ISO_QUERYABLE_NAME = "AnyText"
  # AnyText is an ISO queryable
  @@CMR_ANYTEXT_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  def process(ogc_filter, cmr_query_hash)
    # the keyword CMR param supports a wilcard
    OgcFilterHelper.process_queryable(ogc_filter, cmr_query_hash, @@ISO_QUERYABLE_NAME, @@CMR_ANYTEXT_PARAM, true)
    Rails.logger.info("OgcFilterAnyText.process: #{cmr_query_hash}")
  end
end