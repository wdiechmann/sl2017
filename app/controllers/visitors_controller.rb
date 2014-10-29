class VisitorsController < ApplicationController
  
  def index
    if current_user.nil?
      if cookies.permanent.signed[:punch_clock].nil?
        @punch_clocks = []
      else
        @punch_clocks = PunchClock.where id: cookies.permanent.signed[:punch_clock]
      end
    else
      @punch_clocks = current_user.account.punch_clocks
    end
  end
  
end
