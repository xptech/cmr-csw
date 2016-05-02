class OgcFilterScienceKeywords
  @@QUERYABLE_NAME = "ScienceKeywords"
  # ScienceKeywords is not an ISO queryable, it is a GCMD / CMR specific queryable
  @@CMR_SCIENCE_KEYWORDS_PARAM = GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES[@@QUERYABLE_NAME][1]

  @@CMR_SCIENCE_KEYWORDS_HIERARCHY_HASH = {
      'science_keywords[0][category]' => nil,
      'science_keywords[1][topic]' => nil,
      'science_keywords[2][term]' => nil,
      'science_keywords[3][variable_level_1]' => nil,
      'science_keywords[4][variable_level_2]' => nil,
      'science_keywords[5][variable_level_3]' => nil,
      # science_keywords[6][detailed_variable]' => nil, # CMR does not supported the detailed_variable
      'options[science_keywords][or]' => true
  }

  # The NASA Science Keywords hierarchy is:
  # CATEGORY / TOPIC / TERM / VARIABLE_LEVEL_1 / VARIABLE_LEVEL_2 / VARIABLE_LEVEL_3 / DETAILED_VARIABLE
  # EARTH SCIENCE (category);TERRESTRIAL HYDROSPHERE (topic);WATER QUALITY/WATER CHEMISTRY (term);
  # WATER TEMPERATURE (variable_level_1);NONE (variable_level_2);NONE (variable_level_3);NONE (detailed_variable)
  # A Science Keyword will be translated to a CMR 'or' query across all the science_keyword classifications with
  # options[science_keywords][or]=true
  def process(ogc_filter)
    # the science_keywords CMR param supports a wilcard
    cmr_query_hash = OgcFilterHelper.process_queryable(ogc_filter, @@QUERYABLE_NAME, @@CMR_SCIENCE_KEYWORDS_PARAM, true)
    # replicate the science_keyword across all types of science keywords and add the or option
    replicate_science_keyword_hierarchy(cmr_query_hash)
    Rails.logger.info("OgcFilterScienceKeywords.process: #{cmr_query_hash}")
    cmr_query_hash
  end


  private
  def replicate_science_keyword_hierarchy(cmr_query_hash)
    if(cmr_query_hash.size >  0)
      science_keyword = cmr_query_hash["#{@@CMR_SCIENCE_KEYWORDS_PARAM}"]
      cmr_query_hash.delete("#{@@CMR_SCIENCE_KEYWORDS_PARAM}")
      @@CMR_SCIENCE_KEYWORDS_HIERARCHY_HASH.each do |key, value|
        if value.nil?
          cmr_query_hash[key] = science_keyword
        else
          cmr_query_hash[key] = value
        end
      end
    end
    cmr_query_hash
  end
end
