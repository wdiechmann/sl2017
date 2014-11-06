class VisitorsController < ApplicationController

  def index
    @jobber = Jobber.new
    render layout: false
  end
  
end
