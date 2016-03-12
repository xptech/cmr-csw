require 'spec_helper'

RSpec.describe GetCapability do
  context 'queryables mappings' do
    let (:total_gcmd_csw_queryables) { 0 }
    let (:total_cmr_csw_queryables) { 0 }
    let (:total_cmr_non_csw_queryables) { 0 }

    # The queryables below will be in the initial CMR CSW implementation
    it 'is possible to identify the supported CMR search parameters which map to GCMD CSW GetCapabilities queryables' do
      cmr_search_params_mapped_to_gcmd_csw = Hash.new
      ISO_QUERYABLES_TO_CMR_QUERYABLES.each do |key, value|
        iso_queryable_name = key
        if !value[0].empty? && !value[1].empty?
          cmr_search_params_mapped_to_gcmd_csw["#{iso_queryable_name}"] =  "#{value[1]}"
        end
      end
      GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES.each do |key, value|
        gcmd_queryable_name = key
        if !value[0].empty? && !value[1].empty?
          cmr_search_params_mapped_to_gcmd_csw["#{gcmd_queryable_name}"] = "#{value[1]}"
        end
      end
      # CMR Search supported a total of 13 GCMD CSW queryables
      expect(cmr_search_params_mapped_to_gcmd_csw.size).to eq 13
      # supported CMR queryable names
      expect(cmr_search_params_mapped_to_gcmd_csw.values).to eq ["entry_title", "keyword", "updated_since", "revision_date",
                                                                 "data_center", "dif_entry_id", "temporal","temporal",
                                                                 "project", "platform", "spatial_keyword", "science_keywords",
                                                                 "instrument"]
      # supported corresponding GCMD CSW Queryable Properties
      expect(cmr_search_params_mapped_to_gcmd_csw.keys).to eq ["Title", "Anytext", "Modified", "RevisionDate",
                                                               "OrganisationName", "ResourceIdentifier", "TempExtent_begin", "TempExtent_end",
                                                               "Project", "Platform", "Location", "ScienceKeywords",
                                                               "Instrument"]
    end

    # The queryables below can only be added to the CMR CSW implementation if the CMR search will support them
   it 'is possible to identify the GCMD queryables which are not supported by CMR search (CSW)' do
     # the queryables below are supported by GCMD and not by CMR
     gcmd_csw_queryables_only = Hash.new
     ISO_QUERYABLES_TO_CMR_QUERYABLES.each do |key, value|
       iso_queryable_name = key
       if !value[0].empty? && value[1].empty?
         gcmd_csw_queryables_only["#{value[0]}"] = value[0]
       end
     end

     GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES.each do |key, value|
       gcmd_queryable_name = key
       if !value[0].empty? && value[1].empty?
         gcmd_csw_queryables_only["#{value[0]}"] = value[0]
       end
     end

     # GCMD queryables NOT supported by CMR search
     # TODO must discuss with Erich Reiter to better understand the meaning of some of the CMR queryables and UMM dataset fields
     expected_unsupported_gcmd_queryables = ["Subject", "Abstract", "Format", "Type", "AlternateTitle", "CreationDate",
                                    "PublicationDate", "HasSecurityConstraints", "Language", "ParentIdentifier",
                                    "KeywordType", "TopicCategory", "ResourceLanguage", "ServiceType", "ServiceTypeVersion",
                                    "Operation", "Denominator", "DistanceValue", "DistanceUOM", "GeographicDescription Code",
                                    "CouplingType", "OperatesOn", "OperatesOnIdentifier", "OperatesOnName", "Lineage",
                                    "ConditionApplyingToAccessAndUse", "AccessConstraints", "OnlineResourceMimeType",
                                    "ResponsiblePartyRole", "OnlineResourceType", "SpecificationDate", "MetadataPointOfContact",
                                    "Classification", "OtherConstraints", "Degree", "SpecificationTitle"]
     # there are 36 GCMD queryables which are not supported by CMR search
     expect(gcmd_csw_queryables_only.size).to eq 36
     unsupported_gcmd_queryable_set = Set.new(expected_unsupported_gcmd_queryables)
     gcmd_csw_queryables_only_set = Set.new(gcmd_csw_queryables_only.keys)
     expect(unsupported_gcmd_queryable_set == gcmd_csw_queryables_only_set).to be true
    end

    # The queryables below can be added to the CMR CSW future implementation to enrich its initial set of supported queryables
    it 'is possible to identify the CMR queryables which are NOT supported by GCMD CSW' do
      cmr_queryables_not_supported_by_gcmd_csw = Array.new
      all_iso_queryables_array = ISO_QUERYABLES_TO_CMR_QUERYABLES.values.flatten
      all_gcmd_specific_queryables_array = GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES.values.flatten
      ALL_CMR_QUERYABLES.keys.each do |key|
        if (all_iso_queryables_array.include?(key))
          # supported by CGMD ISO Queryables
          next
        else
          if (all_gcmd_specific_queryables_array.include?(key))
            #supported by GCMD specific queryables
            next
          else
            # not supported by GCMD CSW
            cmr_queryables_not_supported_by_gcmd_csw << key
          end
        end
      end
      expect(cmr_queryables_not_supported_by_gcmd_csw.length).to eq 20
      # CMR queryables NOT supported by CSW
      # TODO - might consider adding them to CMR CSW
      expected_cmr_queryables_not_supported_by_gcmd_csw_set = Set.new(["concept_id", "echo_collection_id", "provider_short_name",
                                                           "dataset_id", "entry_id", "archive_center", "processing_level_id",
                                                           "collection_data_type", "online_only", "downloadable", "browse_only",
                                                           "browsable", "provider", "short_name", "version", "polygon",
                                                           "bounding_box", "point", "line", "has_granules"])
      expect(expected_cmr_queryables_not_supported_by_gcmd_csw_set).to eq Set.new(cmr_queryables_not_supported_by_gcmd_csw)
    end
  end
end