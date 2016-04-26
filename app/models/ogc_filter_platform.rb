class OgcFilterPlatform

  @@ISO_QUERYABLE_NAME = "Platform"
  # platform is not an ISO queryable, it is a GCMD / CMR specific queryable
  @@CMR_PLATFORM_PARAM = GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  def process(ogc_filter, cmr_query_hash)
    # the platform CMR param supports a wilcard
    OgcFilterHelper.process_queryable(ogc_filter, cmr_query_hash, @@ISO_QUERYABLE_NAME, @@CMR_PLATFORM_PARAM, true)
    Rails.logger.info("OgcFilterPlatform.process: #{cmr_query_hash}")
  end

end