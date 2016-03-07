class DescribeRecordController < ApplicationController
  # TODO: implement this
  def index
    # create DescribeRecord model
    # set model variable to be used in the view below

    # render view
    render 'describe_record/index.xml.erb', :status => :ok and return
  end
end
