module ApplicationHelper
  def to_records(raw_collections_doc, output_schema, response_element, result_root_element)
    output_schema_label = 'iso_gmi'
    if output_schema == 'http://www.opengis.net/cat/csw/2.0.2'
      output_schema_label = 'csw'
    end
    translate(raw_collections_doc, "app/helpers/#{output_schema_label}_#{response_element}.xslt", result_root_element)
  end

  def translate(document, stylesheet, result_root_element)
    template = Nokogiri::XSLT(File.read(stylesheet))

    transformed_document = template.transform(document,  Nokogiri::XSLT.quote_params(['result_root_element', result_root_element]))

    transformed_document.to_xml
  end
end
