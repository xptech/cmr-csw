require 'spec_helper'

RSpec.describe GetCapability do
  describe 'queryables mappings' do
    it 'is possible to identify the supported CMR search parameters which map to GCMD CSW GetCapabilities queryables' do
      cmr_search_params = Hash.new
      ISO_QUERYABLES_TO_CMR_QUERYABLES.each do |key, value|
        iso_queryable_name = key
        if !value[0].empty? && !value[1].empty?
          cmr_search_params["#{value[1]}"] = value[0]
        end
      end
      GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES.each do |key, value|
        iso_queryable_name = key
        if !value[0].empty? && !value[1].empty?
          cmr_search_params["#{value[1]}"] = value[0]
        end
      end
      # the 12 queryables below are supported by CMR and can be mapped to GCMD queryables
      expect(cmr_search_params.size).to eq 12
      expect(cmr_search_params.keys).to eq ["entry_title", "keyword", "updated_since", "revision_date", "data_center",
                                            "dif_entry_id", "temporal", "project", "platform", "spatial_keyword", "science_keywords", "instrument"]
      #GetCapability.CMR_SPECIFIC_QUERYABLES_TO_ISO_QUERYABLES.each do |key, value|
      #  iso_queryable_name = key
      #end

      #expect(h.ok?).to eq(true)

    end

    it 'is possible to indentify the supported GCMD queryables in CMR search (CSW)' do
      #h = Health.new
      #expect(h.ok?).to eq(false)
    end

    it 'is possible to identify the unsupported GCMD queryables in the CMR search (CSW)' do
      #h = Health.new
      #expect(h.ok?).to eq(false)
    end

    it 'is possible to identify the unsupported ISO Queryables in GCMD CSW' do
      #h = Health.new
      #expect(h.ok?).to eq(false)
    end
  end
end