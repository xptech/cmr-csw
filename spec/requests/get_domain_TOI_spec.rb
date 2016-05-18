require 'spec_helper'

RSpec.describe 'GetDomain http GET TOI (TimeExtent_begin and TimeExtent_end success scenarios', :type => :request do

  it 'correctly renders the response for a the TimeExtent_begin PropertyName' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_begin'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('TempExtent_begin')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('9999-12-31T23:59:59Z')
  end

  it 'correctly renders the response for a the TimeExtent_end PropertyName' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_end'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('TempExtent_end')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MinValue',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('0000-01-01T00:00:00Z')
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:RangeOfValues/csw:MaxValue',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('9999-12-31T23:59:59Z')
  end

  it 'correctly renders the response for an unnkown property' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'UNKNOWN_PROPERTY'
    expect(response).to have_http_status(:success)
    expect(response).to render_template('get_domain/index.xml.erb')
    domain_xml = Nokogiri::XML(response.body)
    expect(domain_xml.root.name).to eq 'GetDomainResponse'
    expect(domain_xml.root.at_xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').text).to eq('UNKNOWN_PROPERTY')
    # for an unknown property, return the property itself and no siblings
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName/following-sibling::*',
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(0)
  end

  it 'correctly renders the response for both TempExtent_begin and TempExtent_end properties' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_begin,TempExtent_end'
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
  end

  it 'correctly renders the response for TempExtent_begin,TempExtent_end and an unknown properties' do
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_begin,TempExtent_end,UNKNOWN_PROPERTY'
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
                                    'csw' => 'http://www.opengis.net/cat/csw/2.0.2')[2].text).to eq('UNKNOWN_PROPERTY')
    # for an unknown property, return the property itself and no siblings
    expect(domain_xml.root.xpath('/csw:GetDomainResponse/csw:DomainValues/csw:PropertyName/following-sibling::*',
                                 'csw' => 'http://www.opengis.net/cat/csw/2.0.2').size).to eq(2)
  end

  it 'correctly renders the response for both TempExtent_begin and TempExtent_end with comma anad whitespace separator' do
    # notice whitespace in PropertyName string
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :PropertyName => 'TempExtent_begin,    TempExtent_end'
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
  end
end

RSpec.describe 'GetDomain http GET error scenarios', :type => :request do
  it 'correctly renders the exception response for a GetDomain without a PropertyName or ParameterNameknown property with ranges' do
    # :propertyName should be :PropertyName
    get '/', :request => 'GetDomain', :service => 'CSW', :version => '2.0.2', :propertyName => 'TimeExtent_begin'
    expect(response).to have_http_status(:bad_request)
    expect(response).to render_template('shared/exception_report.xml.erb')
    records_xml = Nokogiri::XML(response.body)
    expect(records_xml.root.name).to eq 'ExceptionReport'
    # There should be a SearchStatus with a timestamp
    exception_node_set = records_xml.root.xpath('/ows:ExceptionReport/ows:Exception', 'ows' => 'http://www.opengis.net/ows')
    expect(exception_node_set.size).to eq(1)
    expect(exception_node_set[0]['exceptionCode']).to eq('InvalidParameterValue')
    expect(exception_node_set[0]['locator']).to eq('NoApplicableCode')
    exception_text = exception_node_set[0].at_xpath('//ows:Exception/ows:ExceptionText', 'ows' => 'http://www.opengis.net/ows')
    expect(exception_text.text).to include("The GetDomain GET request requires either a ParameterName or a PropertyName.")
  end

  ## Same Property twice
  ## TempExtentBegin test

  ## TODO basic service and version errors

end