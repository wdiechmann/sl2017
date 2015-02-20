class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @assignments = Assignment.all
    respond_with(@assignments)
  end

  def show
    respond_with(@assignment)
  end

  def new
    @assignment = Assignment.new
    respond_with(@assignment)
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)
    flash[:notice] = 'Assignment was successfully created.' if @assignment.save
    respond_with(@assignment)
  end

  def update
    flash[:notice] = 'Assignment was successfully updated.' if @assignment.update(assignment_params)
    respond_with(@assignment)
  end

  def destroy
    @assignment.destroy
    respond_with(@assignment)
  end

  private
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def assignment_params
      params.require(:assignment).permit(:job_id, :jobber_id, :assigned_at, :assigned_id, :assigned_type, :withdrawn_at, :withdrawn_id, :withdrawn_type)
    end
end
