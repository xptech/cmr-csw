class GetRecordsController < ApplicationController
  def index
    begin
      gr = GetRecords.new(params, request)
      if gr.valid?
        @model = gr.find
        render 'get_records/index.xml.erb', :status => :ok and return
      else
        @exceptions = []
        gr.errors.each do |attribute, error|
          @exceptions.append OwsException.new(attribute, error)
        end
        render 'shared/exception_report.xml.erb', :status => :bad_request and return
      end
    rescue OwsException => e
      # exception not captured via the ActiveModel:Validation framework
      @exceptions = []
      @exceptions.append e
      render 'shared/exception_report.xml.erb', :status => :bad_request and return
    end
  end
end

