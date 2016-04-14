module GetRecordByIdHelper
  def to_records(raw_collections, output_schema, response_element)
    if output_schema == 'http://www.isotc211.org/2005/gmi'
      if response_element == 'full'
        collections = translate(raw_collections, 'app/helpers/iso_gmi_full.xslt')
      elsif response_element == 'summary'
        collections = translate(raw_collections, 'app/helpers/iso_gmi_summary.xslt')
      elsif response_element == 'brief'
        collections = translate(raw_collections, 'app/helpers/iso_gmi_brief.xslt')
      end
    elsif output_schema == 'http://www.opengis.net/cat/csw/2.0.2'
      if response_element == 'full'
        collections = translate(raw_collections, 'app/helpers/csw_full.xslt')
      elsif response_element == 'summary'
        collections = translate(raw_collections, 'app/helpers/csw_summary.xslt')
      elsif response_element == 'brief'
        collections = translate(raw_collections, 'app/helpers/csw_brief.xslt')
      end
    end
    collections
  end

  def translate(collections, stylesheet)
    Rails.logger.info "Collection: #{collections}"
    document = Nokogiri::XML(collections)
    template = Nokogiri::XSLT(File.read(stylesheet))

    transformed_document = template.transform(document)

    transformed_document.to_xml
  end
end
