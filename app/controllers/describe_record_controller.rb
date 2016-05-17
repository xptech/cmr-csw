class DescribeRecordController < ApplicationController
  def index
    # Switch on schema requested
    dr = DescribeRecord.new(params, request)
    if dr.valid?
      @describe_record_model = dr.get_model
      render 'describe_record/index.xml.erb', :status => :ok and return
    else
      @exceptions = []
      dr.errors.each do |attribute, error|
        @exceptions.append OwsException.new(attribute, error)
      end
      render 'shared/exception_report.xml.erb', :status => :bad_request and return
    end
  end
end
