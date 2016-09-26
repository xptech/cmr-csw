require 'benchmark'

RSpec.describe "various Nokogiri performance tests with CMR XML responses", :type => :request do
  it 'inspects performance for adding the CWIC keywords to the largest possible CMR response' do
    input_document = File.open('spec/fixtures/helpers/2000_records.xml') { |f| Nokogiri::XML(f) }
    time = Benchmark.realtime do
      document_with_cwic_keywords = BaseCswModel.add_cwic_keywords(input_document)
    end
    Rails.logger.info "Adding CWIC keywords took #{(time.to_f * 1000).round(0)} ms"
  end
end
