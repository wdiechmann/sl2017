class VisitorsController < ApplicationController
  
  def index
    @employees = Employee.all
  end
end
