class GetRecordByIdController < ApplicationController
  # TODO: implement this
  def index
    # create GetRecordById model
    # set model variable to be used in the view below

    # render view
    render 'get_record_by_id/index.xml.erb', :status => :ok and return
  end
end
