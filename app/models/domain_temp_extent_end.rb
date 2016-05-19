class DomainTempExtentEnd
  @@name = 'TempExtent_end'
  # formatting is important so that the get_domain/index.xml.erb is properly indented
  @@domain_xml = %{<csw:RangeOfValues>
            <csw:MinValue>0000-01-01T00:00:00Z</csw:MinValue>
            <csw:MaxValue>9999-12-31T23:59:59Z</csw:MaxValue>
          </csw:RangeOfValues>}

  def self.domain_xml
    return @@domain_xml
  end
end