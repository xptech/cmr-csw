class GetDomainController < ApplicationController

  # TODO: implement this
  def index
    # create GetDomain model
    # set model variable to be used in the view below

    # render view
    render 'get_domain/index.xml.erb', :status => :ok and return
  end
end
