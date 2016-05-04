require 'spec_helper'

describe 'view documentation' do
  include Capybara::DSL

  it 'contains the relevant static markup from the layout' do
    visit '/'
    within('section.hero') do
      title = find('h1')
      expect(title.text).to eq('Catalog Service for the Web')
    end

    within('section.content') do
      sub_title = find('h1')
      expect(sub_title.text).to eq('Supported requests')
      expect(page).to have_content('version 2.0.2')
      expect(page).to have_link('Catalog Service for the Web (CSW)', href: 'http://www.opengeospatial.org/standards/cat')
    end

    within('footer') do
      expect(page).to have_link("Release: #{Rails.configuration.version.strip}")
      expect(page).to have_link('Andrew Mitchell')
      expect(page).to have_content('NASA Official: Andrew Mitchell')
    end

  end

  it 'contains the correct description of GetCapabilities' do
    visit '/'
    within('section.get-capabilities') do
      expect(page).to have_css("h2:contains('GetCapabilities')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-formats') do
        expect(page).to have_content('application/xml')
      end
    end
  end

  it 'contains the correct description of GetRecords' do
    visit '/'
    within('section.get-records') do
      expect(page).to have_css("h2:contains('GetRecords')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_no_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported element set names')")
      within('ul.response-elements') do
        expect(page).to have_content('brief')
        expect(page).to have_content('summary')
        expect(page).to have_content('full')
      end
      expect(page).to have_css("h3:contains('Supported result types')")
      within('ul.result-types') do
        expect(page).to have_content('hits')
        expect(page).to have_content('results')
      end
      expect(page).to have_css("h3:contains('Supported output schemas')")
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-schemas') do
        expect(page).to have_link('ISO', href: 'http://www.isotc211.org/2005/gmi')
        expect(page).to have_link('CSW', href: 'http://www.opengis.net/cat/csw/2.0.2')
      end
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-formats') do
        expect(page).to have_content('application/xml')
      end
    end
  end

  it 'contains the correct description of GetRecordById' do
    visit '/'
    within('section.get-record-by-id') do
      expect(page).to have_css("h2:contains('GetRecordById')")
      expect(page).to have_css("h3:contains('Supported methods')")
      within('ul.methods') do
        expect(page).to have_content('GET')
        expect(page).to have_content('POST')
      end
      expect(page).to have_css("h3:contains('Supported element set names')")
      within('ul.response-elements') do
        expect(page).to have_content('brief')
        expect(page).to have_content('summary')
        expect(page).to have_content('full')
      end

      expect(page).to have_css("h3:contains('Supported output schemas')")
      within('ul.output-schemas') do
        expect(page).to have_link('ISO', href: 'http://www.isotc211.org/2005/gmi')
        expect(page).to have_link('CSW', href: 'http://www.opengis.net/cat/csw/2.0.2')
      end
      expect(page).to have_css("h3:contains('Supported output formats')")
      within('ul.output-formats') do
        expect(page).to have_content('application/xml')
      end
    end
  end
end