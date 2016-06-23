class CqlParser < Parslet::Parser
  # example string to parse: BoundingBox=-180.00,-90.00, 180.000, 90 and AnyText=MODIS and TempExtent_begin=1990-09-03T00:00:01Z and TempExtent_end=2008­09­06T23:59:59Z

  # one or more spaces
  rule(:space)                  { match('\s').repeat(1) }
  # maybe, maybe not
  rule(:space?)                 { space.maybe }

  rule(:cqlconstraint_bbox)     { space? >> str('BoundingBox').as(:key) >> space? }
  rule(:cqlconstraint_anytext)  { space? >> str('AnyText').as(:key) >> space? }
  rule(:cqlconstraint_tbegin)   { space? >> str('TempExtent_begin').as(:key) >> space? }
  rule(:cqlconstraint_tend)     { space? >> str('TempExtent_end').as(:key) >> space? }
  rule(:equals)                 { space? >> str('=') >> space? }
  rule(:value)                  { space? >> match['[:alnum:]\-\+\*\?\,\:\.'].repeat(1).as(:value) >> space? }

  rule(:operator)       { space? >> str('and') >> space? }
  rule(:operator?)      { operator.maybe }

  rule(:cqlquery)       { ((cqlconstraint_bbox |  cqlconstraint_anytext | cqlconstraint_tbegin | cqlconstraint_tend) >> equals >> value >> operator?).repeat }

  root(:cqlquery)

end