class OgcFilterEntryTitle

  @@ISO_QUERYABLE_NAME = "Title"
  # Title is an ISO queryable
  @@CMR_TITLE_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  def process(ogc_filter, cmr_query_hash)
    # the entry_title CMR param supports a wilcard
    OgcFilterHelper.process_queryable(ogc_filter, cmr_query_hash, @@ISO_QUERYABLE_NAME, @@CMR_TITLE_PARAM, true)
    Rails.logger.info("OgcFilterEntryTitle.process: #{cmr_query_hash}")
  end
end