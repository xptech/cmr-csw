class GetRecordsController < ApplicationController
  # TODO: implement this
  def index
    # create GetRecords model
    # set model variable to be used in the view below

    # render view
    render 'get_records/index.xml.erb', :status => :ok and return
  end
end
