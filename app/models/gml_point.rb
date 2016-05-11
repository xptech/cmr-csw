class GmlPoint
  # the CMR point is specified as LON LAT (ex. -180 -90)
  # the gml:Point is gml:pos TWO whitespace separated coordinates
  # See: http://www.georss.org/gml.html#gmlpoint
  include ActiveModel::Validations

  attr_accessor :longitude
  validates :longitude,
            :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180, :message => "%{value} must be between -180 and 180 degrees"},
            :presence => {:message => 'must be between -180 and 180 degrees'}

  attr_accessor :latitude
  validates :latitude,
            :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90, :message => "%{value} must be between -90 and 90 degrees"},
            :presence => {:message => 'must be between -90 and 90 degrees'}

  def initialize(point_longitude, point_latitude)
    @longitude = point_longitude
    @latitude = point_latitude
  end

  def ==(other)
    self.class === other and
        other.longitude == @longitude and
        other.latitude == @latitude
  end

  alias eql? ==

  def hash
    @longitude.hash ^ @latitude.hash # XOR
  end

  def to_s
    return "(lon #{@latitude} lat #{@longitude}"
  end
end