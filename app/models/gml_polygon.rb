class GmlPolygon
  # the CMR Polygon is specified as LON1,LAT1,LON2,LAT2, ... ,LONn,LATn,LON1,LAT1
  # the gml:Polygon is a list of gml:posList whitespace separated coordinates
  include ActiveModel::Validations

  attr_accessor :gml_point_array
    # custom validators for the point array, individual points are validated by the GmlPoint validation
    validate :validate_array_length
    validate :validate_closed_polygon
    validate :validate_lon_lat_points

  def initialize(gml_polygon_xml_node)
    @gml_point_array = nil
    coordinates_string = gml_polygon_xml_node.at_xpath('//gml:posList', 'gml' => 'http://www.opengis.net/gml')
    if(coordinates_string != nil && coordinates_string.text != nil)
      # split on whitespace
      @gml_point_array = coordinates_string.text.split
    end
  end

  # CMR query is: bounding_box =  lower left longitude, lower left latitude, upper right longitude, upper right latitude
  def to_cmr
    "#{gml_point_array.join(',')}"
  end

  private
  def validate_array_length
    if !gml_point_array.is_a?(Array) || gml_point_array.size == 0 || gml_point_array.size % 2 != 0
      errors.add :gml_point_array,  "gml:posList - must be a space separated string of LON LAT point coordinates"
    end
  end

  def validate_closed_polygon
    first_lon = gml_point_array[0]
    first_lat = gml_point_array[1]
    total_coords = gml_point_array.size
    last_lon = gml_point_array[total_coords - 2]
    last_lat = gml_point_array[total_coords - 1]
    if first_lon != last_lon || first_lat != last_lat
      errors.add :gml_point_array, "gml:posList - first (#{first_lon} #{first_lat}) and last (#{last_lon} #{last_lat}) point of the polygon must be indentical"
    end
  end

  def validate_lon_lat_points
    # only validate points if there are no errors
    if errors.size == 0
      for i in 0..(gml_point_array.size / 2 - 1) do
        point = GmlPoint.new(gml_point_array[i*2], gml_point_array[i*2 + 1])
        if !point.valid?
          point.errors.each { |k,v| errors.add(k, v) }
        end
      end
    end
  end
end