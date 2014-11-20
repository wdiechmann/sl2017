class VisitorsController < ApplicationController

  def index
    @jobber = Jobber.new
    @message = Message.new
    render layout: false
  end
  
end
