class GetRecordByIdController < ApplicationController
  def index
    begin
      grbi = GetRecordById.new(params, request)
      if grbi.valid?
        @model = grbi.submit
        render 'get_record_by_id/index.xml.erb', :status => :ok and return
      else
        # Need to refactor this to play nicer with rails validations
        raise OwsException.new('MissingParameterValue', "id #{grbi.errors[:id].join(" ")}", 'id', '400')
      end

    rescue OwsException => e
      render xml: e.to_xml, :status => e.http_code and return
    end
  end
end
