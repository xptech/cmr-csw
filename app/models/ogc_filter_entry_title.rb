class OgcFilterEntryTitle

  @@CMR_ENTRY_TITLE_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES["Title"][1]

  def process(ogc_filter, cmr_query_hash)
    title_node_set = ogc_filter.xpath('//ogc:PropertyName[contains(text(), "Title")]', 'ogc' => 'http://www.opengis.net/ogc')
    if (title_node_set != nil && title_node_set[0] != nil)
      entry_title_literal_node = title_node_set[0].next_element
      if (entry_title_literal_node != nil)
        literal_value = entry_title_literal_node.text
        # the cmr entry title supports multitple values, only support one value for now
        cmr_query_hash["#{@@CMR_ENTRY_TITLE_PARAM}"] = literal_value
      end
      process_wildcard(entry_title_literal_node, cmr_query_hash)
    end
    Rails.logger.info("OgcFilterEntryTitle.process: #{cmr_query_hash}")
  end

  private
  def process_wildcard(cmr_entry_title, cmr_query_hash)
    property_parent_node = cmr_entry_title.parent
    wilcard_attribute = property_parent_node['wildCard']
    entry_title_literal_value = cmr_query_hash["#{@@CMR_ENTRY_TITLE_PARAM}"]
    if (!wilcard_attribute.blank? && entry_title_literal_value.include?(wilcard_attribute))
      cmr_query_hash["options[#{@@CMR_ENTRY_TITLE_PARAM}][pattern]"] = true
      # replace wildcard occurence with CMR wildcard character
      if (wilcard_attribute != '*')
        cmr_query_hash["#{@@CMR_ENTRY_TITLE_PARAM}"] = entry_title_literal_value.gsub(wilcard_attribute, '*')
      end
    end
  end
end