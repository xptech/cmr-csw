class OgcFilterBoundingBox
  # since bouding box requires special processing, we cannot  use the OgcFilterHelper
  # CMR query is: bounding_box =  lower left longitude, lower left latitude, upper right longitude, upper right latitude.
  # gml iso:boundingbox envelope is:
  # <gml:lowerCorner>LONG LAT</gml:lowerCorner>
  # <gml:upperCorner>LONG (-180 to + 180) LAT (-90 to +90)</gml:upperCorner>
  def process(ogc_filter)
    cmr_query_hash = {}
    cmr_bounding_box_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["BoundingBox"][1]
    bounding_box = ogc_filter.xpath('//ogc:PropertyName[contains(text(), "BoundingBox")]', 'ogc' => 'http://www.opengis.net/ogc')
    if (bounding_box != nil && bounding_box[0] != nil)
      bounding_box_envelope_node = bounding_box[0].next_element
      if (bounding_box_envelope_node != nil)
        iso_bounding_box = IsoBoundingBox.new(bounding_box_envelope_node)
        if(iso_bounding_box.valid?)
          # the cmr bounding_box only supports a single value and not an array
          cmr_query_hash["#{cmr_bounding_box_param}"] = iso_bounding_box.to_cmr
        else
          error_message = "not in the supported ISO format. #{iso_bounding_box.errors.full_messages.to_s}"
          Rails.logger.error(error_message)
          raise OwsException.new('BoundingBox', error_message)
        end
      end
    end
    Rails.logger.info("OgcFilterBoundingBox.process: #{cmr_query_hash}")
    cmr_query_hash
  end
end