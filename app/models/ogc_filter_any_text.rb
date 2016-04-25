class OgcFilterAnyText
  def process(ogc_filter, cmr_query_hash)
    cmr_keyword_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["AnyText"][1]
    any_text = ogc_filter.xpath('//ogc:PropertyName[contains(text(), "AnyText")]', 'ogc' => 'http://www.opengis.net/ogc')
    if (any_text != nil && any_text[0] != nil)
      any_text_literal_node = any_text[0].next_element
      if (any_text_literal_node != nil)
        literal_value = any_text_literal_node.text
        # the cmr keyword only supports a single value and not an array
        cmr_query_hash["#{cmr_keyword_param}"] = literal_value
      end
    end
    Rails.logger.info("OgcFilterAnyText.process: #{cmr_query_hash}")
  end
end