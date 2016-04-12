class GetRecordByIdController < ApplicationController
  def index
    begin
      grbi = GetRecordById.new(params, request)
      if grbi.valid?
        @model = grbi.submit
        render 'get_record_by_id/index.xml.erb', :status => :ok and return
      else
        # Need to refactor this to play nicer with rails validations
        # What if we have multiple validation problems?
        raise OwsException.new('MissingParameterValue', grbi.errors[:id].join(' '), 'id', '400') unless grbi.errors[:id].blank?
        raise OwsException.new('InvalidParameterValue', grbi.errors[:version].join(' '), 'version', '400') unless grbi.errors[:version].blank?
        raise OwsException.new('InvalidParameterValue', grbi.errors[:service].join(' '), 'service', '400') unless grbi.errors[:service].blank?
      end

    rescue OwsException => e
      render xml: e.to_xml, :status => e.http_code and return
    end
  end
end
