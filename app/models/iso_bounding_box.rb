class IsoBoundingBox
  include ActiveModel::Validations

  attr_accessor :lower_corner_longitude
  validates :lower_corner_longitude,
            :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180, :message => 'lowerCorner longitude must be between -180 and 180 degrees'},
            :presence => {:message => 'must be between -180 and 180 degrees'}

  attr_accessor :lower_corner_latitude
  validates :lower_corner_latitude,
            :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90, :message => 'lowerCorner latitude must be between -90 and 90 degrees'},
            :presence => {:message => 'must be between -90 and 90 degrees'}

  attr_accessor :upper_corner_longitude
  validates :upper_corner_longitude,
            :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180, :message => 'upperCorner longitude must be between -180 and 180 degrees'},
            :presence => {:message => 'must be between -180 and 180 degrees'}

  attr_accessor :upper_corner_latitude
  validates :upper_corner_latitude,
            :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90, :message => 'upperCorner latitude must be between -90 and 90 degrees'},
            :presence => {:message => 'must be between -90 and 90 degrees'}

  def initialize(bounding_box_envelope_xml)
    @lower_corner_latitude = nil
    @lower_corner_longitude = nil
    @upper_corner_latitude = nil
    @upper_corner_longitude = nil
    lower_corner_node = bounding_box_envelope_xml.at_xpath('//gml:lowerCorner', 'gml' => 'http://www.opengis.net/gml')
    if(lower_corner_node != nil)
      @lower_corner_longitude, @lower_corner_latitude = process_lon_lat(lower_corner_node.text)
    end
    upper_corner_node = bounding_box_envelope_xml.at_xpath('//gml:upperCorner', 'gml' => 'http://www.opengis.net/gml')
    if(upper_corner_node != nil)
      @upper_corner_longitude, @upper_corner_latitude = process_lon_lat(upper_corner_node.text)
    end
  end

  # CMR query is: bounding_box =  lower left longitude, lower left latitude, upper right longitude, upper right latitude
  def to_cmr
    "#{@lower_corner_longitude},#{@lower_corner_latitude},#{@upper_corner_longitude},#{@upper_corner_latitude}"
  end

  private
    def process_lon_lat(lon_lat)
      a = nil
      if(!lon_lat.blank?)
        a = lon_lat.split(/\s+/)
      end
      return a
    end
end