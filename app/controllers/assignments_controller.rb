
AWAITING = 0
JOBBER_OK = 1
JOBBER_DECLINE = 2
DT_OK = 4
DT_DECLINE = 8
WATERMARK = 15

class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show,
    :edit, :update, :destroy, :accepted_by_jobber, :accepted_by_dt, :declined_by_jobber, :declined_by_dt]

  before_filter :authenticate_user!, except: [ :accepted_by_jobber,
    :accepted_by_dt, :declined_by_jobber, :declined_by_dt]
  after_action :verify_authorized

  respond_to :html

  def index
    @assignments = Assignment.all
    respond_with(@assignments)
    authorize Assignment
  end

  def accepted_by_jobber
    set_status(JOBBER_OK)
    render layout: false
    authorize @assignment
  end

  def accepted_by_dt
    set_status(DT_OK)
    render layout: false
    authorize @assignment
  end

  def declined_by_jobber
    set_status(JOBBER_DECLINE)
    @assignment.update_attributes(withdrawn_at: Time.now, withdrawn_reason: params[:reason], with_drawer: @assignment.jobber) if params[:reason]
    render layout: false
    authorize @assignment
  end

  def declined_by_dt
    set_status(DT_DECLINE)
    @assignment.update_attributes(withdrawn_at: Time.now, withdrawn_reason: params[:reason], with_drawer: @assignment.job.delivery_team) if params[:reason]
    render layout: false
    authorize @assignment
  end

  def show
    respond_with(@assignment)
    authorize @assignment
  end

  def new
    @assignment = Assignment.new
    respond_with(@assignment)
    authorize @assignment
  end

  def edit
    authorize @assignment
  end

  def create
    @assignment = Assignment.new(assignment_params)
    flash[:notice] = 'Assignment was successfully created.' if @assignment.save
    respond_with(@assignment)
    authorize @assignment
  end

  def update
    flash[:notice] = 'Assignment was successfully updated.' if @assignment.update(assignment_params)
    respond_with(@assignment)
    authorize @assignment
  end

  def destroy
    @assignment.destroy
    respond_with(@assignment)
    authorize @assignment
  end

  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def set_status(status)
      @assignment.status = AWAITING if (@assignment.status.nil? || @assignment.status > WATERMARK || @assignment.status.blank?)
      status = @assignment.status + status
      @assignment.update_attributes(status: status)
    end


    def assignment_params
      params.require(:assignment).permit(:job_id, :jobber_id, :assigned_at, :assigned_id, :assigned_type, :withdrawn_at, :withdrawer_id, :withdrawer_type, :withdrawn_reason)
    end
end
