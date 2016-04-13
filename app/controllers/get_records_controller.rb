class GetRecordsController < ApplicationController
  def index
    gr = GetRecords.new(params, request)
    begin
      if gr.is_valid()
        @get_records_model = gr.submit
        render 'get_records/index.xml.erb', :status => :ok and return
      end
    # TODO might want to rescue ALL exceptions not just OwsException
    rescue OwsException => e
      render xml: e.to_xml, :status => e.http_code and return
    end
  end
end
