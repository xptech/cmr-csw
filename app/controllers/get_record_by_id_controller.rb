class GetRecordByIdController < ApplicationController
  def index
    begin
      grbi = GetRecordById.new(params, request)
      if grbi.valid?
        @model = grbi.find
        render 'get_record_by_id/index.xml.erb', :status => :ok and return
      else
        @exceptions = []
        grbi.errors.each do |attribute, error|
          @exceptions.append OwsException.new(attribute, error)
        end
        render 'shared/exception_report.xml.erb', :status => :bad_request and return
      end
    end
  end
end
