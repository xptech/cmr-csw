require 'spec_helper'

RSpec.describe 'GetDomain http GET "Platform" queryable success scenarios', :type => :request do

  it 'correctly renders the response for the Platform  PropertyName' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'Platform'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('Platform')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Name',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('NASA Global Change Master Directory (GCMD). GCMD Keywords.')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Document',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmdservices.gsfc.nasa.gov/static/kms/platforms/platforms.csv')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Authority',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmd.nasa.gov/learn/keyword_list.html')
  end

  it 'correctly renders the response for TempExtent_begin,TempExtent_end,Modified, Platform properties' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_begin,TempExtent_end, Modified, Platform'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('TempExtent_begin')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('9999-12-31T23:59:59Z')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('TempExtent_end')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('9999-12-31T23:59:59Z')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[2].text).to eq('Modified')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[2].text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[2].text).to eq('9999-12-31T23:59:59Z')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[3].text).to eq('Platform')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Name',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('NASA Global Change Master Directory (GCMD). GCMD Keywords.')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Document',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmdservices.gsfc.nasa.gov/static/kms/platforms/platforms.csv')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Authority',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmd.nasa.gov/learn/keyword_list.html')
  end

  it 'correctly renders the response for Platform and an unknown property' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'Platform,UNKNOWN_PROPERTY'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[0].text).to eq('Platform')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Name',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('NASA Global Change Master Directory (GCMD). GCMD Keywords.')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Document',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmdservices.gsfc.nasa.gov/static/kms/platforms/platforms.csv')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:ConceptualScheme/csw:Authority',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('http://gcmd.nasa.gov/learn/keyword_list.html')

    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[1].text).to eq('UNKNOWN_PROPERTY')
    # for an unknown property, return the property itself and no siblings
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName/following-sibling::*',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(1)
  end
end

RSpec.describe 'GetDomain http GET "Platform" queryable error scenarios', :type => :request do
  # The error specs are not property specific. See the get_domain_modified_get_spec error spec for PropertyName.
end